resource "aws_s3_bucket" "vitBucket" {
     bucket = "my-prod-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Terraform = "True"
  }
  
}

resource "aws_s3_bucket_policy" "vitBucket" {
  bucket = aws_s3_bucket.vitBucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "ACCESSPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.vitBucket.arn,
          "${aws_s3_bucket.vitBucket.arn}/*",
        ]
        Condition = {
          NotIpAddress = {
            "aws:SourceIp" = "8.8.8.8/32"
          }
        }
      },
    ]
  })
}