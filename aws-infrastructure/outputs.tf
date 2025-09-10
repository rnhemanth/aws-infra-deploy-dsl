output "vpc_id" {
  value = aws_vpc.dsl.id
}

output "general_bucket_name" {
  value = aws_s3_bucket.general.id
}

output "certificates_bucket_name" {
  value = aws_s3_bucket.certificates.id
}

output "datasync_role_arn" {
  value = aws_iam_role.datasync.arn
}

output "vpc_endpoint_datasync_dns" {
  value = aws_vpc_endpoint.datasync.dns_entry[0].dns_name
}

output "kms_key_id" {
  value = aws_kms_key.certificates.id
}