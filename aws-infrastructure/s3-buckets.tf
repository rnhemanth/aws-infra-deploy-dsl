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

# Versioning for both buckets
resource "aws_s3_bucket_versioning" "general" {
  bucket = aws_s3_bucket.general.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "certificates" {
  bucket = aws_s3_bucket.certificates.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Encryption for general bucket (AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "general" {
  bucket = aws_s3_bucket.general.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Encryption for certificates bucket (KMS)
resource "aws_s3_bucket_server_side_encryption_configuration" "certificates" {
  bucket = aws_s3_bucket.certificates.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.certificates.arn
    }
    bucket_key_enabled = true
  }
}

# Block public access for both buckets
resource "aws_s3_bucket_public_access_block" "general" {
  bucket = aws_s3_bucket.general.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "certificates" {
  bucket = aws_s3_bucket.certificates.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle policies
resource "aws_s3_bucket_lifecycle_configuration" "general" {
  bucket = aws_s3_bucket.general.id
  
  rule {
    id     = "archive-old-files"
    status = "Enabled"
    
    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }
    
    transition {
      days          = 180
      storage_class = "GLACIER"
    }
  }
}

# Bucket policies
resource "aws_s3_bucket_policy" "certificates" {
  bucket = aws_s3_bucket.certificates.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyUnencryptedObjectUploads"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.certificates.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "aws:kms"
          }
        }
      }
    ]
  })
}