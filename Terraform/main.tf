provider "aws" {
  region = "us-east-1"
}

variable "image_uri" {
  description = "URI of the Docker image to deploy"
}

resource "aws_security_group" "instance_sg" {
  name        = "allow_web_and_ssh"
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
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = "t2.micro"
  key_name                    = "starpi-app"
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    curl -fsSL https://get.docker.com | sh
    docker pull ${var.image_uri}
    docker run -it -d -p 1337:1337 --name strapi ${var.image_uri}
  EOF
  tags = {
    Name = "Strapi-Deployment"
  }
}

output "instance_ip" {
  value = aws_instance.ubuntu_ec2.public_ip
}