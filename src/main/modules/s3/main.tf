#LogsBucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.name

}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id
    rule {
      object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

#resource "aws_s3_bucket_server_side_encryption_configuration" "s3_pn_confinfo_LogsBucke" {
#  bucket = aws_s3_bucket.bucket.id
#
#  rule {
#    apply_server_side_encryption_by_default {
#      kms_master_key_id = aws_kms_key.kms_pn_confinfo_LogsBucket.arn
#      sse_algorithm     = "aws:kms"
#    }
#  }
#}