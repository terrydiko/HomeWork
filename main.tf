resource "aws_s3_bucket" "hallelujahchoir" {
  bucket = "majoombum"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.Joekms.arn
        sse_algorithm     = "aws:kms"
      }
    }

  }
  tags = {
    "Name" = "majoombum"
  }

}

resource "aws_iam_role" "joerole" {
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
  role = aws_iam_role.joerole.id
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
  role = aws_iam_role.joerole.name

}

resource "aws_instance" "joe-Instance" {
  ami                         = var.ami
  instance_type               = var.Instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2-insatnce-profile.name

}

resource "aws_kms_key" "Joekms" { # how to consume policy whils creating the key
  description         = "key used to encrypt bucket"
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.Key_policy.json #referencing data key policy .json



}

