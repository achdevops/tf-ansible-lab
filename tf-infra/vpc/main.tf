module "vpc" {
  source = "../../tf-modules/network"

  name_prefix            = "cloudlabs-${var.environment}"
  vpc_cidr              = "17.0.0.0/16"
  public_subnet_cidrs   = ["17.0.1.0/24"]
  private_subnet_cidrs  = ["17.0.3.0/24"]
  enable_nat_gateway    = false

  tags = {
    Environment = var.environment
    Project     = "cloudlabs"
    Owner       = "devsecops team"
  }
}