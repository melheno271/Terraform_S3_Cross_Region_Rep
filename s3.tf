resource "aws_s3_bucket" "source" {
  provider = aws.source
  bucket   = "tf-test-bucket-source-987654"
}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.source

  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "destination" {
  provider = aws.destination
  bucket = "tf-test-bucket-destination-987654"
}

resource "aws_s3_bucket_versioning" "destination" {
  provider = aws.destination
  bucket = aws_s3_bucket.destination.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.source
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source.id

  rule {
    id = "replication"

    filter {
      tag {
        key = "replication"
        value = "true"
      }
    }

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
    delete_marker_replication {
      status = "Disabled"
    }
  }
}