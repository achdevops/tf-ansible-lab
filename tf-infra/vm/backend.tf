terraform {
  required_version = ">= 1.12"
  
  backend "s3" {
    bucket         = "tf-ansible-cloudlabs"
    key            = "tf-vm.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-ansible-cloudlabs-state-lock"
    profile        = "cloudlabs"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2"
    }
  }
}

provider "aws" {
  profile = "cloudlabs"
  region  = "us-east-1"
}