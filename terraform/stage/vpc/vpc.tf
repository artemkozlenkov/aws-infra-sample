locals {
  vpc_name = "simple-${basename(path.cwd)}"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = local.vpc_name
  cidr = "10.0.0.0/16"

  azs              = ["${var.region}a", "${var.region}b"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", ]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.7.0/24", "10.0.8.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "${local.vpc_name}-public-${var.region}"
    Tier = "Public"
  }

  tags = {
    Terraform   = true
    Environment = "stage"
  }

  vpc_tags = {
    Name = local.vpc_name
  }
}
