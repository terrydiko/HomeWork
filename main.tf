resource "aws_s3_bucket" "Group6Bucket" {
  bucket = var.Group6TestBucket
  acl    = "private"
  tags = {
    Name        = "Mybucket"
    Environment = "Dev"
  }
}
resource "aws_iam_role" "s3bucketRole" {
  name = "test_role"

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

  tags = {
    tag-key = "TestPolicy"
  }
}
resource "aws_iam_policy" "Group6Policy" {
  name        = "RolePolicy"
  path        = "/"
  description = "Group6TestPolicy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1638756555546",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
})
}