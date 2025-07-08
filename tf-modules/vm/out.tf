# Security Group Outputs
output "web_security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "internal_security_group_id" {
  description = "ID of the internal security group"
  value       = aws_security_group.internal.id
}

# Elastic IP Outputs
output "foo_elastic_ip" {
  description = "Elastic IP address for foo instance"
  value       = aws_eip.foo.public_ip
}

output "foo_elastic_ip_allocation_id" {
  description = "Allocation ID of the Elastic IP for foo instance"
  value       = aws_eip.foo.allocation_id
}

# EC2 Instance Outputs
output "foo_instance_id" {
  description = "ID of the foo EC2 instance"
  value       = aws_instance.foo.id
}

output "bar_instance_id" {
  description = "ID of the bar EC2 instance"
  value       = aws_instance.bar.id
}

output "foo_private_ip" {
  description = "Private IP address of foo instance"
  value       = aws_instance.foo.private_ip
}

output "bar_private_ip" {
  description = "Private IP address of bar instance"
  value       = aws_instance.bar.private_ip
}

# Key Pair Output
output "key_pair_name" {
  description = "Name of the created key pair"
  value       = aws_key_pair.main.key_name
}