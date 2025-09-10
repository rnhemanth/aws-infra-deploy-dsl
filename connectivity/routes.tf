# Get route table IDs
data "aws_route_tables" "onprem" {
  vpc_id = var.onprem_vpc_id
}

data "aws_route_tables" "aws" {
  vpc_id = var.aws_vpc_id
}

# Add routes for peering
resource "aws_route" "onprem_to_aws" {
  for_each = toset(data.aws_route_tables.onprem.ids)
  
  route_table_id            = each.value
  destination_cidr_block    = "100.88.173.128/26"
  vpc_peering_connection_id = aws_vpc_peering_connection.simulated_dx.id
}

resource "aws_route" "aws_to_onprem" {
  for_each = toset(data.aws_route_tables.aws.ids)
  
  route_table_id            = each.value
  destination_cidr_block    = "10.100.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.simulated_dx.id
}