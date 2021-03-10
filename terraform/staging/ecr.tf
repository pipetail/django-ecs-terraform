data "aws_ecr_repository" "nginx" {
  name = "nginx"
}

data "aws_ecr_repository" "django" {
  name = "django"
}

resource "aws_ecr_repository" "nginx" {
  count                = var.env == "production" ? 1 : 0
  name                 = "nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "django" {
  count                = var.env == "production" ? 1 : 0
  name                 = "django"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "django-cache" {
  count                = var.env == "production" ? 1 : 0
  name                 = "django-cache"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
