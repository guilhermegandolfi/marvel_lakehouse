#####################################################################################################
## policy to use in sqs for information in raw data
#####################################################################################################

data "aws_iam_policy_document" "aws_iam_policy_document_sqs_raw_data" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    sid       = "1"
    actions   = ["sqs:SendMessage", ]
    resources = ["${aws_sqs_queue.aws_sqs_queue_raw_data.arn}", ]

    condition {
      test     = "ArnEquals"
      values   = ["${aws_s3_bucket.aws_s3_bucket_raw_data.arn}"]
      variable = "aws:SourceArn"
    }

  }

}
