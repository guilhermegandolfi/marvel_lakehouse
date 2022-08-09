########################################################
## SQS
########################################################
resource "aws_sqs_queue" "aws_sqs_queue_raw_data" {
  name = "sqs_thanos_lakehouse_raw_data_ny_taxis"
  tags = var.aws_tags
 
}
resource "aws_sqs_queue_policy" "aws_sqs_queue_policy_raw_data" {
  queue_url = aws_sqs_queue.aws_sqs_queue_raw_data.id
  policy    = data.aws_iam_policy_document.aws_iam_policy_document_sqs_raw_data.json

}

