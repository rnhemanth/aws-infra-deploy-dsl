resource "aws_vpc_peering_connection" "simulated_dx" {
  peer_vpc_id = var.aws_vpc_id
  vpc_id      = var.onprem_vpc_id
  auto_accept = true
  
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  
  tags = {
    Name = "simulates-directconnect-tgw"
  }
}