resource "aws_s3_bucket" "kenes3" {
    bucket = var.bucket_name
    acl    = "private"
  tags = {
    Name        = "My bucket"
  }
    server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kenkey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
resource "aws_kms_key" "kenkey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
}
resource "aws_iam_role" "s3_role" {
    name = var.role_name
    assume_role_policy = jsonencode(
    {
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_role_policy" {
    name = "s3_role_policy"
    role = aws_iam_role.s3_role.id
    policy = jsonencode(
            {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Sid": "s3getandputObject",
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
            }
        
        ]
        })
}