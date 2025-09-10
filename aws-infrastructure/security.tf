resource "aws_security_group" "datasync" {
  name   = "${var.environment}-datasync-endpoint-sg"
  vpc_id = aws_vpc.dsl.id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.100.0.0/16"]  # From on-prem
  }
  
  ingress {
    from_port   = 1024
    to_port     = 1064
    protocol    = "tcp"
    cidr_blocks = ["10.100.0.0/16"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}