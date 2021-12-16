resource "aws_kms_key" "DevKey" {
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation = true
  policy = data.aws_iam_policy_document.key_policy.json
  
}

resource "aws_s3_bucket" "dev_team_bucket" {
  bucket = var.MyDevBucket
  acl    = "private"

  tags = {
    Name        = "Dev bucket"
    Environment = "Dev"
    Terraform = true

  }
    server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.DevKey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

data "aws_caller_identity" "current" {
  
}

data "aws_iam_policy_document" "key_policy" {
  statement {
    sid = "allow root usr full access"
    effect = "Allow"
    principals {
        type = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = ["kms:*"]
    resources = ["*",]
  }

}