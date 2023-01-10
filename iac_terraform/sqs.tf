########################################################
## SQS
########################################################
resource "aws_sqs_queue" "aws_sqs_queue_bronze_data" {
  name = "sqs_marvel_bronze_data"
  tags = var.aws_tags
 
}

resource "aws_sqs_queue_policy" "aws_sqs_queue_policy_raw_data" {
  queue_url = aws_sqs_queue.aws_sqs_queue_raw_data.id
  policy    = data.aws_iam_policy_document.aws_iam_policy_document_sqs_raw_data.json

}

