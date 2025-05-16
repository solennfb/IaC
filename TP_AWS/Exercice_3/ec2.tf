# Déclaration AWS EC2 

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # AMi fictive
  instance_type = var.ec2_instance_type

  tags = {
    Name = var.ec2_instance_name
  }
  security_groups = [aws_security_group.allow_ssh]
}

resource "aws_instance" "db_server" {
  ami                    = "ami-12345678"  # AMI fictive 
  instance_type          = "t2.micro"

  tags = {
    Name = "database-server"
    Role = "database"

  
  }
  security_groups = [ aws_security_group.db_sg ]
}
