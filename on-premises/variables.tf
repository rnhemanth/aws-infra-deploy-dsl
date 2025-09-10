variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "ssh_public_key" {
  description = "SSH public key content (if not provided, one will be generated)"
  type        = string
  default     = ""
}