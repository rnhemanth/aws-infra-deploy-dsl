variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "deploy_buckets" {
  description = "Whether to deploy S3 buckets"
  type        = bool
  default     = true
}

variable "deploy_vpc" {
  description = "Whether to deploy VPC"
  type        = bool
  default     = true
}