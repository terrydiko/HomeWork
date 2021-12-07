resource "aws_s3_bucket" "Molikig" {
   bucket = "my-moliki-gitbucket"
   acl    = "private"
  tags = {
    Name        = "My-bucket"
  }
}
resource "aws_iam_role" "ec2_s3_role" {
  name = "s3fullaccess_role"
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
resource "aws_iam_role_policy" "s3fullaccess_policy" {
  name = "s3_policy"
  role = aws_iam_role.ec2_s3_role.id
  policy = jsonencode({
    Version = "2012-10-17"
       "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
      },
    ]
  })
}
resource "aws_iam_instance_profile" "s3_profile" {
  name = "ec2instance_profile"
  role = aws_iam_role.ec2_s3_role.name
}
resource "aws_instance" "s3instance" {
      ami  = "ami-0ed9277fb7eb570c9"
      instance_type = "t2.micro"
      key_name = "NovaKP"
      iam_instance_profile = aws_iam_instance_profile.s3_profile.id
      associate_public_ip_address = true
      user_data = <<EOF
       #!/bin/bash
        sudo chown ec2-user /var/log
       aws s3 cp /var/log s3://my-moliki-gitbucket --recursive
EOF
  tags = {
    Name = "group3"
  }
}