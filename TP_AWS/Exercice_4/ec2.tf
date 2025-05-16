resource "aws_instance" "atelier_instance" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2 - us-east-1
  instance_type               = "t2.micro"

  # Sélectionne le premier subnet du VPC par défaut
  subnet_id                   = tolist(data.aws_subnets.default.ids)[0]

  # Nom exact de la paire de clés existante sur AWS
  key_name                    = "atelier-key"

  # Association du Security Group défini dans security_group.tf
  vpc_security_group_ids      = [aws_security_group.atelier_sg.id]

  tags = {
    Name = "atelier-instance"
  }
}
