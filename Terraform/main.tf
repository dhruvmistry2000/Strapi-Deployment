provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "instance_sg" {
  name        = "Strapi-app"
  description = "Allow SSH, HTTP, HTTPS and port 1337"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "strapi-deployment" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    curl -fsSL https://get.docker.com | sh
    sudo docker pull ${var.image_uri}
    sudo docker run -it -d -p 1337:1337 --name strapi ${var.image_uri}
  EOF
  tags = {
    Name = "Strapi-Deployment"
  }
}

output "instance_ip" {
  value = aws_instance.strapi-deployment.public_ip
}