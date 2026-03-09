resource "aws_sqs_queue" "transactions" {
  name = "${var.project_name}-${var.environment}-transactions-sqs"

  visibility_timeout_seconds = 120
  receive_wait_time_seconds  = 20
}
