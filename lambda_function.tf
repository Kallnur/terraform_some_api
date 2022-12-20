resource "aws_lambda_function" "easy_function" {
  function_name    = var.name
  role             = aws_iam_role.lambda.arn
  runtime          = "nodejs18.x"
  handler          = "lambda_function.lambda_handler"
  filename         = data.archive_file.lambda_code.output_path
  source_code_hash = data.archive_file.lambda_code.output_base64sha256
  tags             = var.tags

  environment {
    variables = {
      OWNER_NAME = "kalnur"
    }
  }
}

data "archive_file" "lambda_code" {
  type        = "zip"
  output_path = "lambda_function.zip"
  source {
    filename = "lambda_function.js"
    content  = file("lambda_function.js")
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.name}-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.name}-iam-role-policy"
  tags   = var.tags
  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid"   : "LoggingPermissions",
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogGroup",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
              ],
              "Resource": [
                  "arn:aws:logs:*:*:*"
              ]
          }
      ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda" {
  name       = "${var.name}-iam-policy-attachment"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}
