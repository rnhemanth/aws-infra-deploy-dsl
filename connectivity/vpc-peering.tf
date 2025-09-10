# This simulates Direct Connect + Transit Gateway
# In production, this would be replaced with actual TGW attachment

data "terraform_remote_state" "onprem" {
  backend = "local"
  config = {
    path = "../on-premises/terraform.tfstate"
  }
}

data "terraform_remote_state" "aws" {
  backend = "local"
  config = {
    path = "../aws-infrastructure/terraform.tfstate"
  }
}

resource "aws_vpc_peering_connection" "simulated_dx" {
  peer_vpc_id = data.terraform_remote_state.aws.outputs.vpc_id
  vpc_id      = data.terraform_remote_state.onprem.outputs.vpc_id
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