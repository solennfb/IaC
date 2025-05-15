variable "docker_image_name" {
  description = "Nom de l'image Docker"
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "Nom du conteneur Docker"
  type        = string
  default     = "nginx-terraform"
}

variable "internal_port" {
  description = "Port interne du conteneur"
  type        = number
  default     = 80
}

variable "external_port" {
  description = "Port externe exposé"
  type        = number
  default     = 8080
}
