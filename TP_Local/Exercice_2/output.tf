output "nginx_container_id" {
  description = "ID du conteneur Docker Nginx"
  value       = docker_container.nginx.id
}