# Security Group Outputs
output "web_security_group_id" {
  description = "ID of the web security group"
  value       = module.ec2.web_security_group_id
}

output "internal_security_group_id" {
  description = "ID of the internal security group"
  value       = module.ec2.internal_security_group_id
}

# Elastic IP Outputs
output "foo_elastic_ip" {
  description = "Elastic IP address for foo instance"
  value       = module.ec2.foo_elastic_ip
}

output "foo_elastic_ip_allocation_id" {
  description = "Allocation ID of the Elastic IP for foo instance"
  value       = module.ec2.foo_elastic_ip_allocation_id
}

# EC2 Instance Outputs
output "foo_instance_id" {
  description = "ID of the foo EC2 instance"
  value       = module.ec2.foo_instance_id
}

output "bar_instance_id" {
  description = "ID of the bar EC2 instance"
  value       = module.ec2.bar_instance_id
}

output "foo_private_ip" {
  description = "Private IP address of foo instance"
  value       = module.ec2.foo_private_ip
}

output "bar_private_ip" {
  description = "Private IP address of bar instance"
  value       = module.ec2.bar_private_ip
}

# Key Pair Output
output "key_pair_name" {
  description = "Name of the created key pair"
  value       = module.ec2.key_pair_name
}

# Combined outputs for convenience
output "instance_summary" {
  description = "Resumen EC2 instances"
  value = {
    foo = {
      instance_id = module.ec2.foo_instance_id
      private_ip  = module.ec2.foo_private_ip
      public_ip   = module.ec2.foo_elastic_ip
    }
    bar = {
      instance_id = module.ec2.bar_instance_id
      private_ip  = module.ec2.bar_private_ip
    }
  }
}