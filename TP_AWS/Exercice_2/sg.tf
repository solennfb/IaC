#Fichier relatif au security group AWS

#autoriser le ssh
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

#règle entrée
  ingress {
    from_port   = var.default_sg_port
    to_port     = var.default_sg_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#règle sortie
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
