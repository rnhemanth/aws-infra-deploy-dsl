# Windows Server
resource "aws_instance" "windows_server" {
  ami           = data.aws_ami.windows_2019.id
  instance_type = "t3.large"
  subnet_id     = aws_subnet.management_vsan.id
  key_name      = aws_key_pair.test.key_name
  
  vpc_security_group_ids = [aws_security_group.onprem.id]
  
  user_data = base64encode(file("${path.module}/scripts/setup-windows.ps1"))
  
  tags = {
    Name = "test-windows-dsl-server"
  }
}

# DataSync Agent
resource "aws_instance" "datasync_agent" {
  ami           = data.aws_ami.datasync.id
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.management_vsan.id
  
  vpc_security_group_ids = [aws_security_group.onprem.id]
  
  tags = {
    Name = "test-datasync-agent"
  }
}

# Data sources
data "aws_ami" "windows_2019" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

data "aws_ami" "datasync" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["aws-datasync-*"]
  }
}

# Key pair
resource "aws_key_pair" "test" {
  key_name   = "dsl-test-key"
  public_key = file("~/.ssh/id_rsa.pub")
}