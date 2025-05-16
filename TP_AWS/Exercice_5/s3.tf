resource "aws_s3_bucket" "atelier_bucket" {
  bucket = "atelier-bucket-solenn-${random_id.bucket_id.hex}"
  force_destroy = true

  tags = {
    Name        = "Atelier Bucket"
    Environment = "Dev"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

# Upload du fichier test-file.txt
resource "aws_s3_object" "test_file" {
  bucket = aws_s3_bucket.atelier_bucket.bucket
  key    = "test-file.txt"
  source = "${path.module}/test-file.txt"
  etag   = filemd5("${path.module}/test-file.txt")
  content_type = "text/plain"
}
