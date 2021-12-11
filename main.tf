resource "aws_s3_bucket" "forjia407" {
  bucket = "forjia407-bucket"
  acl    = "private"

  tags = {
    Name        = "My-bucket"
    Environment = "test"
  }
}

resource "aws_iam_role" "s3_role" {
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
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3_role_policy" {
       name = "s3_role_policy"
   role =  aws_iam_role.s3_role.id
   policy = jsonencode(
   {
  "Version": "2012-10-17",
  "Statement": [
     {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.forjia407.arn}"
    },
    {
      "Sid": "s3_get_and_put_object",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.forjia407.arn}/*"
    },
     {
      "Sid": "Stmt1639247966646",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::forjia407",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption-aws-kms-key-id": "AES256"
        }
      },
      "Principal": "*"
    },
    {
      "Sid": "Stmt1639248084822",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::forjia407",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption-aws-kms-key-id": "AES256"
        }
      },
      "Principal": "*"
    }
  ]
}
   )
}