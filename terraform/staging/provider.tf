provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "pipetail-django-ecs-terraform-poc"
    key            = "infra-staging"
    region         = "eu-west-1"
    dynamodb_table = "terraform-backend"
    encrypt        = true
  }
}
