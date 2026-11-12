terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
  }

  required_version = ">= 1.10.3"
}

provider "aws" {
  region = "ap-northeast-1"
}

variable "account_id" {
  type = string
}

resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = "terraform-state-bucket-${var.account_id}"
}

resource "aws_ecr_repository" "bun-repository" {
  name = "bun-tf-app"
}

resource "aws_ecs_cluster" "bun-cluster" {
  name = "bun-tf-cluster"
}

data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "bun-task" {
  family = "bun-tf-task"
  container_definitions = jsonencode(
    [
      {
        "name" : "bun-tf-task",
        "image" : "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${aws_ecr_repository.bun-repository.name}:latest",
        "networkMode" : "awsvpc",
        "portMappings" : [
          {
            "name" : "bun-tf-app-mapping",
            "hostPort" : 3000,
            "containerPort" : 3000,
            "appProtocol" : "http",
            "protocol" : "tcp"
          }
        ],
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "/ecs/",
            "awslogs-create-group" : "true",
            "awslogs-region" : "ap-northeast-1",
            "awslogs-stream-prefix" : "ecs"
          },
          "secretOptions" : []
        },
        "essential" : true
      }
    ]
  )
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.ecsTaskExecutionRole.arn
  skip_destroy             = true
}

resource "aws_ecs_service" "bun-service" {
  name                    = "bun-tf-service"
  cluster                 = aws_ecs_cluster.bun-cluster.arn
  task_definition         = aws_ecs_task_definition.bun-task.arn
  desired_count           = 1
  enable_ecs_managed_tags = true
  launch_type             = "FARGATE"
  network_configuration {
    subnets = [
      "subnet-0820aaa6de2a55ceb",
      "subnet-01813380387ceb925",
      "subnet-0db6e9287047d8257"
    ]
    security_groups  = ["sg-0fb2b69ae967c2fb6"]
    assign_public_ip = true
  }
  depends_on = [
    aws_ecs_task_definition.bun-task,
    aws_ecs_cluster.bun-cluster
  ]
}
