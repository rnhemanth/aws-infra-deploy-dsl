terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

variable "agent_ip" {
  description = "DataSync agent IP address"
  type        = string
  default     = ""
}

variable "windows_ip" {
  description = "Windows server IP address"
  type        = string
  default     = ""
}

variable "general_bucket" {
  description = "General files S3 bucket name"
  type        = string
  default     = ""
}

variable "certs_bucket" {
  description = "Certificates S3 bucket name"
  type        = string
  default     = ""
}

# Get the agent ARN (assumes it's already activated)
data "aws_datasync_agent" "main" {
  ip_address = var.agent_ip
}

# Get IAM role ARN
data "aws_iam_role" "datasync" {
  name = "test-datasync-role"  # Adjust based on environment
}

# SMB Location
resource "aws_datasync_location_smb" "source" {
  server_hostname = var.windows_ip
  subdirectory    = "/DSL$"
  
  user     = "datasync"
  password = "DataSync123!"
  
  agent_arns = [data.aws_datasync_agent.main.arn]
  
  tags = {
    Name = "test-dsl-smb-source"
  }
}

# S3 Location for general files
resource "aws_datasync_location_s3" "general" {
  s3_bucket_arn = "arn:aws:s3:::${var.general_bucket}"
  subdirectory  = "/"
  
  s3_config {
    bucket_access_role_arn = data.aws_iam_role.datasync.arn
  }
  
  tags = {
    Name = "test-dsl-general-destination"
  }
}

# S3 Location for certificates
resource "aws_datasync_location_s3" "certificates" {
  s3_bucket_arn = "arn:aws:s3:::${var.certs_bucket}"
  subdirectory  = "/"
  
  s3_config {
    bucket_access_role_arn = data.aws_iam_role.datasync.arn
  }
  
  tags = {
    Name = "test-dsl-certificates-destination"
  }
}

# Task for general files
resource "aws_datasync_task" "general_files" {
  source_location_arn      = aws_datasync_location_smb.source.arn
  destination_location_arn = aws_datasync_location_s3.general.arn
  name                     = "test-general-files-sync"
  
  excludes {
    filter_type = "SIMPLE_PATTERN"
    value      = "*.pem|*.crt|*.cer|*.key|*.pfx|*.p12|*.jks"
  }
  
  options {
    bytes_per_second       = 10485760  # 10 MB/s limit for testing
    verify_mode           = "POINT_IN_TIME_CONSISTENT"
    overwrite_mode        = "ALWAYS"
    preserve_deleted_files = "REMOVE"
    task_queueing         = "ENABLED"
  }
  
  tags = {
    Name = "test-general-files-task"
  }
}

# Task for certificates
resource "aws_datasync_task" "certificate_files" {
  source_location_arn      = aws_datasync_location_smb.source.arn
  destination_location_arn = aws_datasync_location_s3.certificates.arn
  name                     = "test-certificates-sync"
  
  includes {
    filter_type = "SIMPLE_PATTERN"
    value      = "*.pem|*.crt|*.cer|*.key|*.pfx|*.p12|*.jks"
  }
  
  options {
    bytes_per_second       = 10485760  # 10 MB/s limit
    verify_mode           = "POINT_IN_TIME_CONSISTENT"
    overwrite_mode        = "ALWAYS"
    preserve_deleted_files = "PRESERVE"  # Keep certs even if deleted from source
    task_queueing         = "ENABLED"
  }
  
  tags = {
    Name = "test-certificates-task"
  }
}

# Outputs
output "general_task_arn" {
  value = aws_datasync_task.general_files.arn
}

output "certificates_task_arn" {
  value = aws_datasync_task.certificate_files.arn
}