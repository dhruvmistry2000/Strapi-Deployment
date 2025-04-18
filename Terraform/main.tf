provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "strapi_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "strapi-vpc"
    }
}

resource "aws_subnet" "strapi_subnet" {
    vpc_id                  = aws_vpc.strapi_vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "strapi-subnet"
    }
}

resource "aws_internet_gateway" "strapi_igw" {
    vpc_id = aws_vpc.strapi_vpc.id

    tags = {
        Name = "strapi-igw"
    }
}

resource "aws_route_table" "strapi_rt" {
    vpc_id = aws_vpc.strapi_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.strapi_igw.id
    }

    tags = {
        Name = "strapi-rt"
    }
}

resource "aws_route_table_association" "strapi_rta" {
    subnet_id      = aws_subnet.strapi_subnet.id
    route_table_id = aws_route_table.strapi_rt.id
}

resource "aws_security_group" "strapi_sg" {
    name        = "strapi-sg"
    description = "Allow SSH and Strapi port"
    vpc_id      = aws_vpc.strapi_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
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

    tags = {
        Name = "strapi-sg"
    }
}

resource "aws_instance" "strapi_ec2" {
    ami                    = "ami-084568db4383264d4"
    instance_type          = "t2.medium"
    key_name               = "starpi-app"
    subnet_id              = aws_subnet.strapi_subnet.id
    vpc_security_group_ids = [aws_security_group.strapi_sg.id]
    associate_public_ip_address = true

    tags = {
        Name = "Strapi-Ec2"
    }

    user_data = <<-EOF
                            #!/bin/bash
                            exec > /var/log/user-data.log 2>&1
                            set -e
                            sudo apt update -y
                            sudo apt install -y curl git build-essential
                            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
                            sudo apt install -y nodejs
                            cd /home/ubuntu/
                            git clone https://github.com/dhruvmistry2000/Strapi-Deployment
                            cd Strapi-Deployment/strapi
                            sudo npm install
                            sudo npm run build
                            sudo npm run develop
                            EOF
}

output "strapi_instance_public_ip" {
    description = "Public IP of the Strapi EC2 instance"
    value       = aws_instance.strapi_ec2.public_ip
}
