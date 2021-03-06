resource "aws_lambda_function" "api_handler" {
  filename         = "${path.module}/lambda/api-handler-build.zip"
  function_name    = "${var.userid}-${var.student}-${var.project}-api-handler"
  role             = var.lambda_role.arn
  source_code_hash = data.archive_file.api_handler.output_base64sha256
  handler          = "src/index.handler"
  runtime          = "nodejs14.x"
  timeout          = 3

  tags = var.tags

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.demo.id
    }
  }
}

resource "null_resource" "yarn_install_api_handler" {
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/lambda/api-handler"
    command     = "yarn --frozen-lockfile --mutex network"
  }
}

data "archive_file" "api_handler" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/api-handler/"
  output_path = "${path.module}/lambda/api-handler-build.zip"

  depends_on = [
    null_resource.yarn_install_api_handler
  ]
}
