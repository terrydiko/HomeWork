resource "aws_kms_key" "homeworkbucketkey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "Homework-bucket" {
  bucket = var.s3-bucket-name
  acl    = "private"

  tags = {
    Name        = "My homework bucket"
    Environment = "Study"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.homeworkbucketkey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}



resource "aws_iam_role" "s3_fullaccess-role" {
  name = "homeworkrole"

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


resource "aws_iam_role_policy" "s3-fullaccess-role-policy" {
  name = "s3_fullaccess_policy"
  role = aws_iam_role.s3_fullaccess-role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "s3fullaccesspolicysid",
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
})
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "ec2_s3_instance_profile"
    role = aws_iam_role.s3_fullaccess-role.name

}


resource "aws_instance" "Homeworkinstance" {
    ami = "ami-0d37e07bd4ff37148"
    instance_type = "t2.micro"
    key_name = "terrkeypair"
    iam_instance_profile = aws_iam_instance_profile.instance_profile.name
    associate_public_ip_address = true
    user_data = <<EOF
    #!/bin/bash
    
    cd  /var/log

    echo "Hello, This is a test file to upload on S3" > mybucketfile.txt

    aws s3 cp mybucketfile.txt  s3://kajidehomework001/

    cd /var/log/

    echo "<html><h1>Hello Cloud Gurus Welcome To My Webpage</h1></html>" >

    index.html

    aws s3 cp mybucketfile.txt  s3://kajidehomework001/

  EOF
}

resource "aws_s3_bucket_object" "Object-upload" {
  bucket =aws_s3_bucket.Homework-bucket.id
  key    = "Myobjectfolder"
  source = "C:/Users/Pascal/OneDrive/Documents/mybucketfile.txt"
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("C:/Users/Pascal/OneDrive/Documents/mybucketfile.txt")
}


