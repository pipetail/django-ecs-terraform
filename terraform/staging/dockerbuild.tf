resource "null_resource" "build" {
  count = var.env == "production" ? 1 : 0
  provisioner "local-exec" {
    environment = {
    }

    command = <<EOT
cd nginx
docker buildx build --platform linux/amd64 -t ${aws_ecr_repository.nginx[count.index].repository_url}:initial .
docker push ${aws_ecr_repository.nginx[count.index].repository_url}:initial
cd ..

cd app
docker buildx build --platform linux/amd64 -t ${aws_ecr_repository.django[count.index].repository_url}:initial .
docker push ${aws_ecr_repository.django[count.index].repository_url}:initial
cd ..
EOT
  }
}
