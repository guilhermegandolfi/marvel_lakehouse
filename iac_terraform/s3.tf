#####################################################################################
## Description:creation of bucket for data lakehouse
## Date: 2022-07-19
#####################################################################################

resource "aws_s3_bucket" "aws_s3_bucket_bronze_data" {
  bucket = "marvel-bronze-${lookup(var.environment, var.env)}"
  acl    = "private"
  tags   = var.aws_tags

}

resource "aws_s3_bucket_versioning" "aws_s3_bucket_versioning_bronze_data" {
  bucket = aws_s3_bucket.aws_s3_bucket_bronze_data.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket" "aws_s3_bucket_silver_data" {
  bucket = "marvel-silver-${lookup(var.environment, var.env)}"
  acl    = "private"
  tags   = var.aws_tags
}


resource "aws_s3_bucket" "aws_s3_bucket_gold_data" {
  bucket = "marvel-gold-${lookup(var.environment, var.env)}"
  acl    = "private"
  tags   = var.aws_tags
}



resource "aws_s3_bucket" "aws_s3_bucket_log_bucket" {
  bucket = "marvel-log-bucket"
  acl    = "private"
  tags   = var.aws_tags
}


resource "aws_s3_bucket_logging" "bronze_log_bucket" {
  bucket = aws_s3_bucket.aws_s3_bucket_bronze_data.id

  target_bucket = aws_s3_bucket.aws_s3_bucket_log_bucket.id
  target_prefix = "bronze/"
}

resource "aws_s3_bucket_logging" "silver_log_bucket" {
  bucket = aws_s3_bucket.aws_s3_bucket_bronze_data.id

  target_bucket = aws_s3_bucket.aws_s3_bucket_log_bucket.id
  target_prefix = "silver/"
}

resource "aws_s3_bucket_logging" "gold_log_bucket" {
  bucket = aws_s3_bucket.aws_s3_bucket_bronze_data.id

  target_bucket = aws_s3_bucket.aws_s3_bucket_log_bucket.id
  target_prefix = "gold/"
}

resource "aws_s3_bucket_notification" "aws_s3_bucket_notification_bronze_data" {
  bucket = aws_s3_bucket.aws_s3_bucket_bronze_data.id
  queue {
    queue_arn = aws_sqs_queue.aws_sqs_queue_bronze_data.arn
    events    = ["s3:ObjectCreated:*"]
  }
}


