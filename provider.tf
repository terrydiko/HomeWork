provider "aws" {
  region = "us-east-1"

}

terraform {
  backend "s3" {
    bucket         = "backs3tera"
    key            = "backendS3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "Backend"
  }
}
