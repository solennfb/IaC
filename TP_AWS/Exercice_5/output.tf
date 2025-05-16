output "instance_public_ip" {
  value       = aws_instance.atelier_instance.public_ip
  description = "Adresse IP publique de l'instance EC2"
}
