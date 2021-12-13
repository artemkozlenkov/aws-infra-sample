variable "region" {
  default = "eu-west-1"
}

variable "dynamodb_table_billing_mode" {
  default = "PAY_PER_REQUEST"
}

variable "tags" {
  default = {
    Owner       = "Artem",
    Terraform   = true,
    Environment = "stage"
    Type        = ""
  }
}


variable "profile" {}
