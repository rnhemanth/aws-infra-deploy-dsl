output "vpc_id" {
  value = aws_vpc.dsl.id
}

output "general_bucket_name" {
  value = aws_s3_bucket.general.id
}

output "certificates_bucket_name" {
  value = aws_s3_bucket.certificates.id
}