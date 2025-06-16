terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn = var.role_arn
  }
}