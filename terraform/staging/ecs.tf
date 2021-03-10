resource "aws_ecs_cluster" "production" {
  name = "${var.ecs_cluster_name}-cluster"
}

resource "aws_launch_configuration" "ecs" {
  name                 = "${var.ecs_cluster_name}-cluster"
  image_id             = lookup(var.amis, var.region)
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.ecs.id]
  iam_instance_profile = aws_iam_instance_profile.ecs.name
  #key_name                    = aws_key_pair.production.key_name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs_cluster_name}-cluster' > /etc/ecs/ecs.config"
}

data "template_file" "app-staging" {
  template = file("../templates/django_app.json.tpl")

  vars = {
    docker_image_url_django = "${data.aws_ecr_repository.django.repository_url}:initial"
    docker_image_url_nginx  = "${data.aws_ecr_repository.nginx.repository_url}:initial"
    region                  = var.region
    rds_db_name             = var.rds_db_name
    rds_username            = var.rds_username
    rds_password            = var.rds_password
    rds_hostname            = aws_db_instance.main.address
    allowed_hosts           = var.allowed_hosts
    env                     = var.env
  }
}

resource "aws_ecs_task_definition" "app-staging" {
  family                = "django-app-staging"
  container_definitions = data.template_file.app-staging.rendered
  depends_on            = [aws_db_instance.main]

  volume {
    name      = "static_volume"
    host_path = "/usr/src/app/staticfiles/"
  }
}

resource "aws_ecs_service" "staging" {
  name            = "staging-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.app-staging.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = 1
  depends_on      = [aws_alb_listener.ecs-alb-http-listener, aws_iam_role_policy.ecs-service-role-policy, null_resource.build]

  lifecycle {
    ignore_changes = [task_definition]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.staging-target-group.arn
    container_name   = "nginx"
    container_port   = 80
  }
}

data "template_file" "migrate" {
  template = file("../templates/django_migrate.json.tpl")

  vars = {
    docker_image_url_django = "${data.aws_ecr_repository.django.repository_url}:initial"
    region                  = var.region
    rds_db_name             = var.rds_db_name
    rds_username            = var.rds_username
    rds_password            = var.rds_password
    rds_hostname            = aws_db_instance.main.address
    allowed_hosts           = var.allowed_hosts
  }
}

resource "aws_ecs_task_definition" "migrate" {
  family                = "django-migrate"
  container_definitions = data.template_file.migrate.rendered
  depends_on            = [aws_db_instance.main]

  volume {
    name      = "static_volume"
    host_path = "/usr/src/app/staticfiles/"
  }
}

resource "aws_ecs_service" "migrate" {
  name            = "${var.ecs_cluster_name}-migrate"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.migrate.arn
  desired_count   = 1

  lifecycle {
    ignore_changes = [task_definition]
  }
}
