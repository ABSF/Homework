resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket
  tags = var.tags
}

resource "aws_s3_bucket_policy" "mybucketpolicy" {
  bucket = aws_s3_bucket.mybucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_s3_bucket.mybucket.id}_DenyAllExceptMyIp"
    Statement = [
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.mybucket.arn,
          "${aws_s3_bucket.mybucket.arn}/*",
        ]
        Condition = {
          NotIpAddress = {
            "aws:SourceIp" = "${var.myip}/32"
          },
          "Bool": {"aws:ViaAWSService": "false"}
        }
      },
    ]
  })
}