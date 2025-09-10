# Client's actual AWS VPC
resource "aws_vpc" "dsl" {
  cidr_block           = "100.88.173.128/26"  # Exactly as specified
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "${var.environment}-dsl-vpc"
  }
}

resource "aws_subnet" "datasync" {
  vpc_id            = aws_vpc.dsl.id
  cidr_block        = "100.88.173.128/27"
  availability_zone = "${var.region}a"
  
  tags = {
    Name = "${var.environment}-dsl-datasync-subnet"
  }
}