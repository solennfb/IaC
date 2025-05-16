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

#Security group pour la bdd

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for DB server"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}
