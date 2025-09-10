output "vpc_id" {
  value = aws_vpc.onprem.id
}

output "datasync_agent_private_ip" {
  value = aws_instance.datasync_agent.private_ip
}

output "windows_server_ip" {
  value = aws_instance.windows_server.public_ip
}