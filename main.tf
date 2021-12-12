resource "aws_s3_bucket" "data_team_bucket" {
  bucket = var.bucket_name
  acl    = "private"
  server_side_encryption_configuration {      
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm =  "aws:kms"
    }
  }
}
  tags = {
    Name        = "joseph_team_bucket"
    Environment = "Dev"
    Terraform = true
  }
}
resource "aws_kms_key" "mykey" {
  description             = "KMS key for SSE encryption"
  enable_key_rotation = true
  policy = data.aws_iam_policy_document.key_policy.json
}

data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "key_policy" {
    statement {
      sid = "Allow root access to this key"
      effect = "Allow"
      principals {
        type = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      }
      actions = ["kms:*"]
      resources = ["*"]
      }
  
}
