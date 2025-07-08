variable "name_prefix" {
  description = "Name prefix for all resources"
  type        = string
  default     = "main"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "12.0.0.0/16"
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/foo-bastion.pem"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
  default     = ""
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where resources will be created"
  type        = string
  default     = ""
}