resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket" "mycharbucket1111" {
  bucket = "mycharbucket1111"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_iam_role" "EC2Role-S3" {
  name = "EC2Role-S3"

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

  tags = {
    tag-key = "EC2RoleforS3"
  }
}
resource "aws_iam_role_policy" "EC2Role_S3Fullaccess_policy" {
  name = "EC2Role_S3Fullaccess_policy"
  role = aws_iam_role.EC2Role-S3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "S3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_instance_profile" "EC2Role_profile" {
  name = "EC2Role_profile"
  role = aws_iam_role.EC2Role-S3.name
}

resource "aws_instance" "web" {
  ami           = "ami-002068ed284fb165b"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.EC2Role_profile.name
  user_data =<<-EOF
             #!/bin/bash 
            yum update -y 
            cd /var/log
            aws s3 cp /var/log s3://mycharbucket1111
            EOF
  tags = {
    Name = "HelloWorld"
  }
}