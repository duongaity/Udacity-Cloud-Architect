output "lambda_greeting" {
  value = aws_lambda_function.greet_lambda_function.environment[0].variables["greeting"]
}
