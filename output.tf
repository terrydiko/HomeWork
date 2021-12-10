output "bucket_arn" {
    value = aws_s3_bucket.homework_bucket.arn
}
output "web_sever_id" {
    value = aws_instance.web_server.id
}