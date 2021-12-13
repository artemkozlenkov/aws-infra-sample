locals {
  vpc_id = data.terraform_remote_state.vpc.vpc_id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
data "template_file" "init" {
  template = file("${path.module}/scripts/init.sh")
}
data "terraform_remote_state" "vpc" {
  backend = "${basename(dirname(path.cwd))}/vpc/"
}

data "aws_subnet" "public" {
  vpc_id = local.vpc_id
}

module "security_groups" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name   = "ssh-group"
  vpc_id = local.vpc_id

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["http-80-tcp", "https-443-tcp"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
module "this" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"

  count = 1

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2micro"
  name          = "${basename(dirname(path.cwd))}_${basename(path.cwd)}"
  user_data     = data.template_file.init.rendered

  key_name = "dev"

  vpc_security_group_ids = [module.security_groups.this_security_group_id]
  subnet_id              = data.aws_subnet.public.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
