#####################################################################################
## Description:creation of bucket for data lakehouse
## Date: 2022-07-19
#####################################################################################

resource "aws_s3_bucket" "aws_s3_bucket_bronze_data" {
  bucket = "marvel-bronze-${lookup(var.environment, var.env)}"
  acl    = "private"
  tags   = var.aws_tags

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "marvel-bronze/"
  }

}


resource "aws_s3_bucket" "aws_s3_bucket_silver_data" {
  bucket = "marvel-silver-${lookup(var.environment, var.env)}"
  acl    = "private"
  tags   = var.aws_tags

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "marvel-silver/"
  }

}


resource "aws_s3_bucket" "aws_s3_bucket_gold_data" {
  bucket = "marvel-gold-${lookup(var.environment, var.env)}"
  acl    = "private"
  tags   = var.aws_tags

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "marvel-gold/"
  }

}


resource "aws_s3_bucket_versioning" "aws_s3_bucket_versioning_raw_data" {
  bucket = aws_s3_bucket.aws_s3_bucket_bronze_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "marvel-log-bucket"
  acl    = "private"
  tags   = var.aws_tags
}

resource "aws_s3_bucket_notification" "aws_s3_bucket_notification_bronze_data" {
  bucket = aws_s3_bucket.aws_s3_bucket_bronze_data.id
  queue {
    queue_arn     = aws_sqs_queue.aws_sqs_queue_bronze_data.arn
    events        = ["s3:ObjectCreated:*"]
  }
}


