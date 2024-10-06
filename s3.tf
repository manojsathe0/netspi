resource "aws_s3_bucket" "netspi_s3bucket" {
  bucket = "netspi-assignment-bucket"
  tags = {
    Name = "netspi-assignment-bucket"
  }
}

resource "aws_s3_bucket_policy" "netspi_s3bucket_policy" {
  bucket = aws_s3_bucket.netspi_s3bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyPublicAccess",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::netspi-assignment-bucket", 
        "arn:aws:s3:::netspi-assignment-bucket/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
EOF
}

resource "aws_s3_bucket_ownership_controls" "netspi_s3bucket_controls" {
  bucket = aws_s3_bucket.netspi_s3bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "netspi_s3bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.netspi_s3bucket_controls]

  bucket = aws_s3_bucket.netspi_s3bucket.id
  acl    = "private"
}