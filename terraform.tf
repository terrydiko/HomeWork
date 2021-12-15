terraform {
  backend "s3" {
    bucket = "kajideterraformbucket"
    key = "HomeWork"
    region = "eu-west-2"
	dynamodb_table = "terraform-lock"
  }
}
