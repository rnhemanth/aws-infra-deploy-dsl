# Production S3 buckets
resource "aws_s3_bucket" "general" {
  bucket = "${var.environment}-dsl-general-shares-${data.aws_caller_identity.current.account_id}"
  
  tags = {
    Name        = "${var.environment}-dsl-general"
    DataType    = "General Files"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "certificates" {
  bucket = "${var.environment}-dsl-secure-certificates-${data.aws_caller_identity.current.account_id}"
  
  tags = {
    Name        = "${var.environment}-dsl-certificates"
    DataType    = "Certificates"
    Compliance  = "High-Security"
    Environment = var.environment
  }
}