variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "cloudlabs"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}