# Deploying Django to AWS ECS with Terraform

## Want to learn how to build this?

Check out the [post](https://testdriven.io/blog/deploying-django-to-ecs-with-terraform/).

1. Set the following environment variables, init Terraform, create the infrastructure:

    ```sh
    $ cd terraform
    $ export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
    $ export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"

    $ terraform init
    $ terraform apply
    ```

2. You can also run the following script to bump the Task Definition and update the Service:

    ```sh
    $ cd deploy
    $ python update-ecs.py --cluster=production-cluster --service=production-service --tag SOMETAG
    ```

## What next?
- Try CodeDeploy for ECS
- Gitlab-CI AutoDevOps
- Switch to Fargate
