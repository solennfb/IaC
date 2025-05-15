terraform {
  #Provider Docker
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

## Configuration de Docker pour se connecter au localhost + port
provider "docker" {
  host = "tcp://localhost:2375"
}

# Création d’un réseau Docker  "nginx_network" partagé entre les 2 conteneurs
resource "docker_network" "my_network" {
  name = "nginx_network"
}

# Téléchargement Image Nginx + utilisation locale
resource "docker_image" "nginx" {
  name         = var.docker_image_name
  keep_locally = true
}

# Deploiement conteneur Nginx (image > ports > réseau partagé)
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

# Conteneur client avec image qui contient curl
resource "docker_container" "client" {
  name  = "client"
  image = "appropriate/curl"

  networks_advanced {
    name = docker_network.my_network.name
  }

  command = [
  "sh", "-c",
  "curl http://nginx-terraform:80 && echo 'OK' && sleep 3600"
]
#  On attend que nginx soit lancé avant d’exécuter la commande sinon erreur
  depends_on = [docker_container.nginx]
}

# Test local exécuté après le déploiement pour vérifier que nginx répond bien
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

#Note : pour tester que le client accède bien à nginx utiliser la commande "docker logs client" pour voir ce qui a été récupéré
