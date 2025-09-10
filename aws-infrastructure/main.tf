# This is what will be deployed in the client's AWS account
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  
  default_tags {
    tags = {
      Environment = var.environment  # dev/staging/prod
      Service     = "DSL"
      Project     = "DSL-Migration"
    }
  }
}