# Déclaration AWS EC2 

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Machine Image utilisée pour créer l'instance
  instance_type = var.ec2_instance_type

  tags = {
    Name = var.ec2_instance_name
  }
}
