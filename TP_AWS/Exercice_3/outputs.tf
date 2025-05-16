#Affiche l'id de l'instance AWS
output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.web.id
}

#Affiche l'ip publique de l'instance
output "instance_public_ip" {
  description = "Adresse IP publique de l'instance"
  value       = aws_instance.web.public_ip
}

#affiche la commande ssh pour se connecter à l'instance
output "ssh_command" {
  description = "Commande SSH pour se connecter à l'instance"
  value       = "ssh -i deployer-key.pem ec2-user@${aws_instance.web.public_ip}"
}

#affiche l'id du bucket S3
output "bucket_id" {
  value       = aws_s3_bucket.demo_bucket.id
  description = "L'identifiant du bucket S3 créé"
}

#affiche l'id de la db
output "db_server_id" {
  value = aws_instance.dbk_server.id
  description = "id de la bdd"
}
