terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "agent_ip" {}
variable "windows_ip" {}
variable "general_bucket" {}
variable "certs_bucket" {}

# This would contain DataSync task configuration
# Added after agent activation