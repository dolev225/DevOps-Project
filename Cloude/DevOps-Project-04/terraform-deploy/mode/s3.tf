resource "aws_s3_bucket" "Clude_s3" {
  bucket = "clude-file-storage-bucket-${var.aws_region}"
  force_destroy = true 

  tags = {
    Name = "Clude_s3"
  }
}

# הגדרת CORS כדי לאפשר העלאת קבצים ישירות מהדפדפן באמצעות Presigned URLs
resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.Clude_s3.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = ["*"]
    expose_headers  = []
  }
}