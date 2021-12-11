provider "aws" {
  region ="eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "kajidestate"
    key    = "windowsterraform/terraform.tfstate"
    region = "eu-west-2"
    dynamodb_table = "state"