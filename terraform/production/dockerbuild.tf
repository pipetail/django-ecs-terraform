resource "null_resource" "build" {
  provisioner "local-exec" {
    environment = {
    }

    command = <<EOT
cd nginx
docker buildx build --platform linux/amd64 -t ${aws_ecr_repository.nginx.repository_url}:initial .
docker push ${aws_ecr_repository.nginx.repository_url}:initial
cd ..

cd app
docker buildx build --platform linux/amd64 -t ${aws_ecr_repository.django.repository_url}:initial .
docker push ${aws_ecr_repository.django.repository_url}:initial
cd ..
EOT
  }
}
