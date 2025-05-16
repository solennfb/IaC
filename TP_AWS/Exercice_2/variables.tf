#variables pour le type d'instance
variable "ec2_instance_type" {
  description = "Type de l'instance EC2"
  type        = string
  default     = "t2.micro"
}

#variable pour le nom de l'instance
variable "ec2_instance_name" {
  description = "Nom de l'instance EC2"
  type        = string
  default     = "ec2-instance"
}

#variable pour le nom du bucket S3
variable "s3_bucket_name" {
  description = "Nom du bucket S3"
  type        = string
  default     = "my-demo-s3-bucket"
}

#variable pour pour du security group
variable "default_sg_port" {
  description = "Port par défaut pour le groupe de sécurité"
  type        = number
  default     = 22
}
