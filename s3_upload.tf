#upload object to source bucket
resource "aws_s3_object" "object" {
  provider = aws.source
  bucket = aws_s3_bucket.source.id
  key    = basename("uploads/file.txt")
  source = "uploads/file.txt"
  tags = {
    "replication" = "true" #tag to allow replication
  }
#dependency for replication:
  depends_on = [
    aws_s3_bucket.source,
    aws_s3_bucket_replication_configuration.replication,
    aws_s3_bucket.destination,
    aws_s3_bucket_versioning.destination,
  ]
}