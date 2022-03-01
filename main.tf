resource "aws_s3_bucket" "forjia407" {
  bucket = var.forjia407-bucket
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name        = "My-bucket"
    Environment = "test"
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation = true
}

resource "aws_iam_role" "role" {
  name = "role"
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

resource "aws_iam_role_policy" "role_policy" {
   role =  aws_iam_role.role.id
   policy = jsonencode(
   {
  "Version": "2012-10-17",
  "Statement": [
     {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
  ]
})
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.forjia407-bucket
  policy = aws_iam_role_policy.role_policy.id
  
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "EC2_instance_profile"
    role = aws_iam_role.role.name
}

resource "aws_instance" "EC2-instance" {
    ami = "ami-0ed9277fb7eb570c9"
    instance_type = "t2.micro"
    key_name = "nova3"
    iam_instance_profile = aws_iam_instance_profile.instance_profile.name
    associate_public_ip_address = true
    tags = {
        Name = "EC2-instance"
    }
  
}