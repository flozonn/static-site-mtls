//impossible d'utiliser KMS, seul SSE convient
//https://www.linkedin.com/pulse/private-amazon-s3-static-website-christopher-white/

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.domain
  tags = {
    Name = var.domain
  }
}

resource "aws_s3_bucket_public_access_block" "block_acl" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.bucket 

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "Policy1415115909152",
    Statement = [
      {
        Sid       = "Access-to-specific-VPCE-only",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:SourceVpce" = var.s3_vpc_endpoint_id
          }
        }
      }
    ]
  })
}

