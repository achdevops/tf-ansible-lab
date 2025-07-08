# Data sources for existing VPC resources
data "aws_vpc" "cloudlabs-vpc" {
  tags = {
    Name = "vpc-cloudlabs-dev"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    #public-subnet-${count.index + 1}-${var.name_prefix}
    values = ["public-subnet-1-cloudlabs-dev"]
  }  
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    #private-subnet-${count.index + 1}-${var.name_prefix}
    values = ["private-subnet-1-cloudlabs-dev"]
  }
}

module "ec2" {
  source = "../../tf-modules/vm"

  name_prefix = "cloudlabs-${var.environment}"
  vpc_cidr = "17.0.0.0/16"
  public_key_path = "~/.ssh/id_rsa.pub"
  instance_type = "t3.micro"
  public_subnet_id = data.aws_subnets.public.ids[0]
  private_subnet_id = data.aws_subnets.private.ids[0]
  vpc_id = data.aws_vpc.cloudlabs-vpc.id
  

  tags = {
    Environment = var.environment
    Project     = "cloudlabs"
    Owner       = "devsecops team"
  }
}