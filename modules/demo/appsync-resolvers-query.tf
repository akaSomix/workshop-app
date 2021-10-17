resource "aws_appsync_resolver" "get_all_users" {
  type              = "Query"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "getAllUsers"
  request_template  = data.template_file.get_all_users.rendered
  response_template = file("${path.module}/resolvers/lambda_proxy.res.vtl")
  data_source       = aws_appsync_datasource.lambda_source.name
  kind              = "UNIT"
}

data "template_file" "get_all_users" {
  template = file("${path.module}/resolvers/lambda_proxy.req.vtl")
  vars = {
    field = "getAllUsers"
  }
}

resource "aws_appsync_resolver" "get_user" {
  type              = "Query"
  api_id            = aws_appsync_graphql_api.demo.id
  field             = "getUser"
  request_template  = data.template_file.get_user.rendered
  response_template = file("${path.module}/resolvers/lambda_proxy.res.vtl")
  data_source       = aws_appsync_datasource.lambda_source.name
  kind              = "UNIT"
}

data "template_file" "get_user" {
  template = file("${path.module}/resolvers/lambda_proxy.req.vtl")
  vars = {
    field = "getUser"
  }
}
