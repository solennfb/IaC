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

# Réseau Docker partagé
resource "docker_network" "my_network" {
  name = "nginx_network"
}

# Image Nginx
resource "docker_image" "nginx" {
  name         = var.docker_image_name
  keep_locally = true
}

# Conteneur Nginx
resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  networks_advanced {
    name = docker_network.my_network.name
  }
}

# Conteneur client avec curl
resource "docker_container" "client" {
  name  = "client"
  image = "appropriate/curl"

  networks_advanced {
    name = docker_network.my_network.name
  }

  command = [
    "sh", "-c",
    "curl http://nginx:80 && echo ' Requête réussie vers nginx' && sleep 3600"
  ]

  depends_on = [docker_container.nginx]
}

# Test automatique (version Windows)
resource "null_resource" "nginx_test" {
  depends_on = [docker_container.nginx]

  provisioner "local-exec" {
    command = <<EOT
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

# Output de l'ID du conteneur nginx
output "nginx_container_id" {
  description = "ID du conteneur Docker Nginx"
  value       = docker_container.nginx.id
}
