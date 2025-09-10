# KMS key for certificate bucket encryption
resource "aws_kms_key" "certificates" {
  description             = "${var.environment}-dsl-certificates-encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  
  tags = {
    Name        = "${var.environment}-dsl-certificates-key"
    Environment = var.environment
  }
}

resource "aws_kms_alias" "certificates" {
  name          = "alias/${var.environment}-dsl-certificates"
  target_key_id = aws_kms_key.certificates.key_id
}

# Allow DataSync to use the key
resource "aws_kms_key_policy" "certificates" {
  key_id = aws_kms_key.certificates.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow DataSync to use the key"
        Effect = "Allow"
        Principal = {
          Service = "datasync.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow S3 to use the key"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })
}