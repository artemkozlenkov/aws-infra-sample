variable "region" {
  default = "eu-west-1"
}

variable "dynamodb_table_name" {
  default = "tfstate_dynamodb"
}

variable "dynamodb_table_billing_mode" {
  default = "PAY_PER_REQUEST"
}

variable "tags" {
  default = {
    Owner       = "Artem",
    Terraform   = true,
    Environment = "stage"
  }
}


variable "profile" {}
