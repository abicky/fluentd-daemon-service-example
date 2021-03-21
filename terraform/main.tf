provider "aws" {}

variable "namespace" {}

data "aws_subnet" "default_1a" {
  default_for_az = true

  filter {
    name   = "availability-zone"
    values = ["ap-northeast-1a"]
  }
}
