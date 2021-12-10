resource "aws_kms_key" "deanskey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 30
}

resource "aws_s3_bucket" "magic_s3_dean" {
  bucket = "magic_s3_dean"
  acl    = "private"
  tags = {
    Name        = "magic_s3_dean"
    ##Environment = "Dev"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.deanskey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_iam_role_policy" "dean_policy" {
  name = "dean_policy"
  role = aws_iam_role.dean_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "dean_role" {
  name = "dean_role"

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