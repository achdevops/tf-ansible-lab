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

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["12.0.1.0/24", "12.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["12.0.3.0/24", "12.0.4.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}