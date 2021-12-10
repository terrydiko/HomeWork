terraform {
  backend "s3" {
    bucket = "ebuka-terraform-state-bucket"
    key    = "Homework_key/key.tfstate"
    region = "us-east-1"
  }
}

#s3 bucket
resource "aws_s3_bucket" "homework_bucket" {
  bucket = "ebukabucket9"
  acl    = "private"
  tags = { Name = "homework-bucket" } 
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.ebuka_kms_key.arn
        sse_algorithm = "aws:kms"
      }
    }
  }
}
# KMS key
resource "aws_kms_key" "ebuka_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10

}


# IAM role
resource "aws_iam_role" "ec2_s3_role" {
    name = "ec2_s3_full_access_role"
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

# IAM Role Policy
resource "aws_iam_role_policy" "s3_full_access" {
  name = "s3_full_access_policy"
  role = aws_iam_role.ec2_s3_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*",
                "kms:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
# Instance profile
resource "aws_iam_instance_profile" "web_instance_profile" {
    name = "web_server_instance_profile"
    role = aws_iam_role.ec2_s3_role.name

}

# EC2 with full s3 access
resource "aws_instance" "web_server" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name = var.webkeypair
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.web_instance_profile.id 



user_data = <<EOF
#! /bin/bash
sudo chown ec2-user /var/log
aws s3 cp /var/log s3://ebukabucket9 --recursive

EOF

  tags = {
    Name = "web-server"
  }
}
