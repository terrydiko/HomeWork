resource "aws_s3_bucket" "hallelujahchoir" {
  bucket = "hallelujahchoir"
  acl    = "private"

  versioning {
    enabled = true
  }
  tags = {
    "Name" = "hallelujahchoir"
  }

}

resource "aws_s3_bucket_policy" "hallelujahchoir policy" {
  bucket = aws_s3_bucket.hallelujahchoir.id
  policy = jsonencode(
    {
      "Id" : "Policy1638343251229",
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Stmt1638343248745",
          "Action" : [
            "s3:DeleteBucket",
            "s3:DeleteObject"
          ],
          "Effect" : "Deny",
          "Resource" : "*",
          "Principal" : "*"
        }
      ]
  })

}

resource "aws_iam_role" "s3role" {
  name = "s3role"
  assume_role_policy = jsonencode(
    {
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

resource "aws_iam_role_policy" "s3policy" {
  name = "s3policy"
  role = aws_iam_role.s3role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ec2actions",
          "Action" : [
            "s3:DeleteBucket",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:PutObject"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
  })

}

resource "aws_iam_instance_profile" "ec2-insatnce-profile" {
  name = "ec2-insatnce-profile"
  role = aws_iam_role.s3role.name

}

resource "aws_instance" "joe-Instance" {
  ami                         = var.ami
  instance_type               = var.Instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2-insatnce-profile.name

}

