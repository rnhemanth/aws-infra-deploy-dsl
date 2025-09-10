# Route table for DataSync subnet
resource "aws_route_table" "datasync" {
  vpc_id = aws_vpc.dsl.id
  
  tags = {
    Name = "${var.environment}-dsl-datasync-rt"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "datasync" {
  subnet_id      = aws_subnet.datasync.id
  route_table_id = aws_route_table.datasync.id
}

# Associate S3 endpoint with route table
resource "aws_vpc_endpoint_route_table_association" "s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.datasync.id
}