terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}

resource "docker_image" "nginx" {
  name         = var.docker_image_name
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }
}

#Tester si le mot Welcome est contenu sur la page nginx
resource "null_resource" "nginx_test" {
  depends_on = [docker_container.nginx]

  provisioner "local-exec" {
    command = <<EOT
#boucle ajouté ici car j'ai des timeout sans
for /l %i in (1,1,10) do (
  curl -s http://localhost:${var.external_port} | findstr "Welcome" >nul
  if not errorlevel 1 (
    echo Test OK : Welcome found in Nginx page
    exit /b 0
  )
  timeout /t 1 >nul
)
echo Test failed : Welcome not found after 10 seconds
exit /b 1
EOT
  }
}
