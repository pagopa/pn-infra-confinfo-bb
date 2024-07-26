output "id" {
  value       = aws_kinesis_stream.stream.id
  description = "This is the id of the stream"
}

output "name" {
  value       = aws_kinesis_stream.stream.name
  description = "This is the name of the stream"
}

output "arn" {
  value       = aws_kinesis_stream.stream.arn
  description = "This is the ARN of the stream"
}