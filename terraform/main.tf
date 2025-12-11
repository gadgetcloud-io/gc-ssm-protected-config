terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Configure backend in backend-config files
    # Usage: terraform init -backend-config=backend-dev.hcl
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "gc"

  default_tags {
    tags = {
      Project     = "Gadgetcloud.io"
      ManagedBy   = "Terraform"
      Repository  = "gc-ssm-protected-config"
      Environment = var.environment
    }
  }
}
