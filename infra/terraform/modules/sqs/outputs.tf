output "queue_arn" {
  value = aws_sqs_queue.transactions.arn
}

output "queue_url" {
  value = aws_sqs_queue.transactions.url
}
