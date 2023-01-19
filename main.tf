#-----------------------------
# Define el provider de aws
#-----------------------------
provider "aws" {
  region = "us-east-1"
}

data "aws_subnet" "az_a" {
  availability_zone = "us-east-1a"
}

data "aws_subnet" "az_b" {
  availability_zone = "us-east-1b"
}

#---------------------------------------
#Define una instancia EC2 con AMI Ubuntu
#---------------------------------------
resource "aws_instance" "servidor_1" {
  ami                    = "ami-052efd3df9dad4825"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.az_a.id
  vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]

  // Escribimos un "here document" que es 
  // usado durante el Cloud init
  user_data = <<-EOF
              #!/bin/bash
              echo "Hola terraformes soy servidor 1!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "servidor-1"
  }
}

resource "aws_instance" "servidor_2" {
  ami                    = "ami-052efd3df9dad4825"
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.az_b.id
  vpc_security_group_ids = [aws_security_group.mi_grupo_de_seguridad.id]

  // Escribimos un "here document" que es 
  // usado durante el Cloud init
  user_data = <<-EOF
              #!/bin/bash
              echo "Hola terraformes soy servidor 2!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "servidor-2"
  }
}

resource "aws_security_group" "mi_grupo_de_seguridad" {
  name = "primer_servidor_sg"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Acceso al puerto 8080 desde el exterior"
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
  }
}