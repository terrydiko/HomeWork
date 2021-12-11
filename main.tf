resource "aws_s3_bucket" "jodowbucket8" {

    bucket = "jodowbucket8"
    acl = "private"

    tags = {
        name = "jodowbucket8"

    }
     server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.magickey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

}

resource "aws_kms_key" "magickey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


resource "aws_iam_role_policy" "s3policy" {
  name = "mys3policy"
  role = aws_iam_role.s3readandwrite.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "s3readandwrite",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
)
}

resource "aws_iam_role" "s3readandwrite" {
  name = "mys3role"

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



resource "aws_iam_instance_profile" "s3HWInstance-Profile" {
  name = "s3HWInstance-Profile"
  role = aws_iam_role.s3readandwrite.name

}

resource "aws_instance" "s3HWInstance" {
  ami                         = "ami-04ad2567c9e3d7893"
  instance_type               = "t2.micro"
  key_name                    = "Jodow-Test-Key"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.s3HWInstance-Profile.id



# I used the following link to get the bash script
# https://www.bogotobogo.com/DevOps/Terraform/Terraform-terraform-userdata.php

user_data = <<EOF
		#! /bin/bash
        sudo chown ec2-user /var/*
        aws s3 cp /var/log/ s3://jodowbucket8 --recursive --exclude "*" --include "*.log" 
	EOF

  tags = {
    "Name" = "s3HWInstance"
  }

}