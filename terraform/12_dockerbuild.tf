resource "null_resource" "build" {
  provisioner "local-exec" {
    environment = {
    }

    command = <<EOT
cd nginx
docker build -t ${aws_ecr_repository.nginx.repository_url}:initial .
docker push ${aws_ecr_repository.nginx.repository_url}:initial
cd ..

cd app
docker build -t ${aws_ecr_repository.django.repository_url}:initial .
docker push ${aws_ecr_repository.django.repository_url}:initial
cd ..
EOT
  }
}
