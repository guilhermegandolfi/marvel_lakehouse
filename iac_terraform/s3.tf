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