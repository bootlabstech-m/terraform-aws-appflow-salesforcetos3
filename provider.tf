terraform {
  required_version = "= 1.6.4" # previous CLI version ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0" # Please check the official doc of terraform/aws before upgrading
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