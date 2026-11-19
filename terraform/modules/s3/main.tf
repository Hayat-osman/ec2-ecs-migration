data "archive_file" "app" {
  type        = "zip"
  output_path = "${path.module}/app.zip"
  source_dir  = "${path.root}/../"
  excludes    = ["terraform", ".git", ".terraform", "*.tfstate", "*.tfstate.backup"]
}

resource "aws_s3_bucket" "app" {
  bucket_prefix = "${var.project_name}-app-"

  tags = {
    Name = "${var.project_name}-app-bucket"
  }
}

resource "aws_s3_bucket_versioning" "app" {
  bucket = aws_s3_bucket.app.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "app" {
  bucket = aws_s3_bucket.app.id
  key    = "app.zip"
  source = data.archive_file.app.output_path
  etag   = filemd5(data.archive_file.app.output_path)
}