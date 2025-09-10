resource "aws_iam_role" "datasync" {
  name = "${var.environment}-datasync-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "datasync.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "datasync_s3" {
  name = "datasync-s3-access"
  role = aws_iam_role.datasync.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ]
        Resource = [
          aws_s3_bucket.general.arn,
          aws_s3_bucket.certificates.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.general.arn}/*",
          "${aws_s3_bucket.certificates.arn}/*"
        ]
      }
    ]
  })
}