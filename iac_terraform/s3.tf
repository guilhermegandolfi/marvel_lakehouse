#####################################################################################
## Description:creation of bucket for data lakehouse
## Date: 2022-07-19
#####################################################################################

resource "aws_s3_bucket" "aws_s3_bucket_raw_data" {
  bucket = "thanos-lakehouse-raw-data-${lookup(var.environment, var.env)}"
  acl    = "private"
  tags   = var.aws_tags

}

resource "aws_s3_bucket_versioning" "aws_s3_bucket_versioning_raw_data" {
  bucket = aws_s3_bucket.aws_s3_bucket_raw_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "aws_s3_bucket_raw_data_lifecycle" {
  bucket = aws_s3_bucket.aws_s3_bucket_raw_data.id

  rule {
    id = "rule-1"

    expiration {
      days = 2
    }

    filter {
      prefix = "ny_taxis/"
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    status = "Enabled"
  }


}


resource "aws_s3_bucket_notification" "aws_s3_bucket_notification_raw_data" {
  bucket = aws_s3_bucket.aws_s3_bucket_raw_data.id
  queue {
    queue_arn     = aws_sqs_queue.aws_sqs_queue_raw_data.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "ny_taxis/"
  }
}


