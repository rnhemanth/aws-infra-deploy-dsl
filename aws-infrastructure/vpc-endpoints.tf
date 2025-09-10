# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.dsl.id
  service_name = "com.amazonaws.${var.region}.s3"
}

# DataSync Interface Endpoint
resource "aws_vpc_endpoint" "datasync" {
  vpc_id              = aws_vpc.dsl.id
  service_name        = "com.amazonaws.${var.region}.datasync"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.datasync.id]
  security_group_ids  = [aws_security_group.datasync.id]
}