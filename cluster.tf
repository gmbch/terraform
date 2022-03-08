terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_ecs_cluster" "airflow-cluster" {
  name = "airflow-test"
  capacity_providers = ["FARGATE"]
}

data "aws_iam_role" "airflow-role" {
  name = "test.workflow"
}

resource "aws_security_group" "airflow-sg" {
  name = "Airflow"
  description = "Airflow test security group"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    
    self = true
    security_groups = var.security_groups_access_workflow
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}