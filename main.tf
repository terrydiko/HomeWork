resource "aws_s3_bucket" "Homework-bucket" {
  bucket = var.s3-bucket-name
  acl    = "private"

  tags = {
    Name        = "My homework bucket"
    Environment = "Study"
  }
}

resource "aws_s3_bucket_object" "examplebucket_object" {
  key = "Firstfolder"
  bucket = aws_s3_bucket.Homework-bucket.id
  source  = "index.html"
  server_side_encryption = "aws:kms"
}

resource "aws_iam_role" "s3_fullaccess-role" {
  name = "homeworkrole"

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
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy" "s3-fullaccess-role-policy" {
  name = "s3_fullaccess_policy"
  role = aws_iam_role.s3_fullaccess-role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "s3fullaccesspolicysid",
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
})
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "ec2_s3_instance_profile"
    role = aws_iam_role.s3_fullaccess-role.name

}


resource "aws_instance" "Homeworkinstance" {
    ami = "ami-0d37e07bd4ff37148"
    instance_type = "t2.micro"
    key_name = "terrkeypair"
    iam_instance_profile = aws_iam_instance_profile.instance_profile.name
    associate_public_ip_address = true
    user_data = <<EOF

    #!/bin/bash

    yum update -y

    yum install httpd -y

    service httpd start

    chkconfig httpd on

    cd /var/log/

    echo "<html><h1>Hello Cloud Gurus Welcome To My Webpage</h1></html>" >

    index.html

    aws s3 mv . s3://var.s3-bucket-name --recursive --exclude "*.DS_Store"

  EOF
}

