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

variable "bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for state locking"
  type        = string
  default     = "terraform-state-lock"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}