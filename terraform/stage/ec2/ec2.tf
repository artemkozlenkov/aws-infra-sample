locals {
  vpc_id             = data.terraform_remote_state.vpc.outputs.id
  tfstate_bucket     = "tfstate-${var.profile}-bucket"
  storage_bucket_arn = data.terraform_remote_state.storage.outputs.arn
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
  backend = "s3"
  config = {
    bucket = local.tfstate_bucket
    key    = "${basename(dirname(path.cwd))}/vpc//terraform.tfstate"
    region = var.region
  }
}
data "terraform_remote_state" "storage" {
  backend = "s3"
  config = {
    bucket = local.tfstate_bucket
    key    = "${basename(dirname(path.cwd))}/s3/storage//terraform.tfstate"
    region = var.region
  }
}
data "aws_subnet_ids" "public" {
  vpc_id = local.vpc_id
  tags = {
    Tier = "Public"
  }
}
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::tfstate-kozlenkov-bucket"]
    effect    = "Allow"
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::tfstate-kozlenkov-bucket/stage/vpc/terraform.tfstate"]
    effect    = "Allow"
  }
}

resource "aws_key_pair" "custom" {
  public_key = file(pathexpand("~/.ssh/custom.pub"))
}
resource "aws_iam_role" "this" {
  name               = "role-ec2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "this_profile" {
  name = "instance_profile"
  role = aws_iam_role.this.name
}
resource "aws_iam_role_policy" "web_iam_role_policy" {
  name   = "s3_iam_role_policy"
  role   = aws_iam_role.this.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${local.storage_bucket_arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["${local.storage_bucket_arn}/*"]
    }
  ]
}
EOF
}

module "security_groups" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.18.0"

  name   = "ssh-group"
  vpc_id = local.vpc_id

  ingress_rules       = ["ssh-tcp", "http-80-tcp", "https-443-tcp", "mysql-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
module "this" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"

  for_each = data.aws_subnet_ids.public.ids

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  name                 = "${basename(dirname(path.cwd))}_${basename(path.cwd)}"
  user_data            = data.template_file.init.rendered
  iam_instance_profile = aws_iam_instance_profile.this_profile.id

  #  ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/custom
  key_name = aws_key_pair.custom.key_name

  vpc_security_group_ids = [module.security_groups.this_security_group_id]
  subnet_id              = each.value

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
