terraform {
  #Provider Docker
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

resource "docker_container" "client" {
  count = var.client_count

  name  = "client-${count.index}"              # Noms uniques : client-0, client-1, ...
  image = "appropriate/curl"

  networks_advanced {
    name = docker_network.my_network.name
  }

  command = [
    "sh", "-c",
    "curl http://nginx:80 && echo ' Client ${count.index} OK' && sleep 30"
  ]

  depends_on = [docker_container.nginx]
}


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

#Note : pour choisir un nombre : terraform apply -var="client_count=5"