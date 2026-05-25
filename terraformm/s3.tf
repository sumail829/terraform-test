resource "aws_s3_bucket" "static" {
  bucket = "suman-static-files-123456"

  tags = {
    Name = "suman-static"
  }
}