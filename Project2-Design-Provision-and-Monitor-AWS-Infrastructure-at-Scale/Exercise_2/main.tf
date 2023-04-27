provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "Udacity_T2" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  count = "4"
  tags = {
    Name = "Udacity T2"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "greet_lambda_function" {
  filename      = "greet_lambda.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greet_lambda.lambda_handler"

  source_code_hash = filebase64sha256("greet_lambda.zip")

  runtime = "python3.7"

  environment {
    variables = {
      greeting = "Hello, Udacity!"
    }
  }
}

resource "aws_cloudwatch_log_group" "greet_lambda_cloudwatch_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.greet_lambda_function.function_name}"
  retention_in_days = 7
}

# Provides an IAM policy
resource "aws_iam_policy" "lambda_logging_iam_policy" {
  name        = "lambda_logging_iam_policy"
  path        = "/"
  description = "A IAM policy for logging from a Lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logging_iam_role_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging_iam_policy.arn
}
