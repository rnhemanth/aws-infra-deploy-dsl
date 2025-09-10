# Simulates on-premises network
resource "aws_vpc" "onprem" {
  cidr_block           = "10.100.0.0/16"  # Simulated on-prem range
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "test-onprem-network"
    Note = "Simulates Management vSAN"
  }
}

resource "aws_subnet" "management_vsan" {
  vpc_id                  = aws_vpc.onprem.id
  cidr_block              = "10.100.50.0/24"  # Management vSAN subnet
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true  # Only for test access
  
  tags = {
    Name = "test-management-vsan"
  }
}

# Internet Gateway for test access only
resource "aws_internet_gateway" "onprem" {
  vpc_id = aws_vpc.onprem.id
  
  tags = {
    Name = "test-onprem-igw"
    Note = "For initial setup only"
  }
}