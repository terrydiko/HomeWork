resource "aws_s3_bucket" "grouptest" {
  bucket = "grouptestserge"
  acl = "private"
}

  resource "aws_iam_role" "test_role" {
  name = "s3_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })
 }
resource "aws_instance" "group1" {
  ami           = "ami-0ed9277fb7eb570c9" # us-east-1
  instance_type = "t2.micro"

 user_data = <<-EOT
    bucket id= {aws_s3_bucket.grouptestserge.id}
    s3 cp s3://grouptestserge/ ./ --recursive

  EOT
}
 
