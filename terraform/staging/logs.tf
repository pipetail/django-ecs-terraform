resource "aws_cloudwatch_log_group" "django-log-group" {
  count             = var.env == "production" ? 1 : 0
  name              = "/ecs/django-app"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "django-log-stream" {
  count          = var.env == "production" ? 1 : 0
  name           = "django-app-log-stream"
  log_group_name = aws_cloudwatch_log_group.django-log-group[0].name
}

resource "aws_cloudwatch_log_group" "nginx-log-group" {
  count             = var.env == "production" ? 1 : 0
  name              = "/ecs/nginx"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "nginx-log-stream" {
  count          = var.env == "production" ? 1 : 0
  name           = "nginx-log-stream"
  log_group_name = aws_cloudwatch_log_group.nginx-log-group[0].name
}
