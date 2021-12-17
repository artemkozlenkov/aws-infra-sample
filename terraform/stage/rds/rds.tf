locals {
  vpc            = data.terraform_remote_state.vpc.outputs
  tfstate_bucket = "tfstate-${var.profile}-bucket"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = local.tfstate_bucket
    key    = "${basename(dirname(path.cwd))}/vpc//terraform.tfstate"
    region = var.region
  }
}

locals {
  name   = "example-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-1"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

################################################################################
# Supporting Resources
################################################################################

resource "random_password" "master" {
  length = 10
}

module "rds-aurora_mysql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "6.1.3"

  name           = local.name
  engine         = "aurora-mysql"
  engine_version = "8.0"
  instances = {
    1 = {
      identifier     = "mysql-static-1"
      instance_class = "db.t4g.medium"
    }
  }

  vpc_id                 = local.vpc.id
  db_subnet_group_name   = local.vpc.database_subnet_group_name
  create_db_subnet_group = false
  create_security_group  = true
  allowed_cidr_blocks    = local.vpc.private_subnets_cidr_blocks

  iam_database_authentication_enabled = true
  master_password                     = random_password.master.result
  create_random_password              = true

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.mysql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.mysql.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = local.tags
}

resource "aws_db_parameter_group" "mysql" {
  name        = "${local.name}-aurora-db-80-parameter-group"
  family      = "aurora-mysql8.0"
  description = "${local.name}-aurora-db-80-parameter-group"
  tags        = local.tags
}

resource "aws_rds_cluster_parameter_group" "mysql" {
  name        = "${local.name}-aurora-80-cluster-parameter-group"
  family      = "aurora-mysql8.0"
  description = "${local.name}-aurora-80-cluster-parameter-group"
  tags        = local.tags
}

