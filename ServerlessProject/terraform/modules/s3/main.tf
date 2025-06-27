resource "aws_s3_bucket" "frontend" {
  bucket = "file-manager-frontend-${var.random_id_suffix}"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "frontend_acl" {
  bucket = aws_s3_bucket.frontend.id
  acl    = var.frontend_bucket_acl
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend.id
  index_document {
    suffix = var.frontend_index_document
  }
  error_document {
    key = var.frontend_error_document
  }
}

resource "aws_s3_bucket" "files" {
  bucket = "file-manager-files-${var.random_id_suffix}"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "files_acl" {
  bucket = aws_s3_bucket.files.id
  acl    = var.files_bucket_acl
}

resource "aws_s3_bucket" "lambda" {
  bucket = "file-manager-lambda-${var.random_id_suffix}"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "lambda_acl" {
  bucket = aws_s3_bucket.lambda.id
  acl    = var.lambda_bucket_acl
}

resource "aws_s3_bucket_public_access_block" "lambda" {
  bucket                  = aws_s3_bucket.lambda.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "files_lambda_crud" {
  bucket = aws_s3_bucket.files.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { "AWS": var.files_bucket_policy_principal },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.files.arn,
          "${aws_s3_bucket.files.arn}/*"
        ]
      }
    ]
  })
}

output "frontend_bucket_name" { value = aws_s3_bucket.frontend.bucket }
output "files_bucket_name"    { value = aws_s3_bucket.files.bucket }
output "lambda_bucket_name" {
  value       = aws_s3_bucket.lambda.bucket
  description = "The name of the S3 bucket for Lambda function packages."
}
