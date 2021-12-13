variable "region" { default = "eu-west-1" }

variable "tags" {
  default = {
    Owner       = "Artem",
    Terraform   = true,
    Environment = "stage"
  }
}
