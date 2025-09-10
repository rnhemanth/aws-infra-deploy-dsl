resource "aws_route_table" "onprem" {
  vpc_id = aws_vpc.onprem.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.onprem.id
  }
}

resource "aws_route_table_association" "onprem" {
  subnet_id      = aws_subnet.management_vsan.id
  route_table_id = aws_route_table.onprem.id
}