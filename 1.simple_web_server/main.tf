terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_security_group" "web_server" {
  name        = "web_app"
  description = "allow HTTP port"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "web_server"
  }
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "allow port 22"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "ssh"
  }
}

resource "aws_instance" "web_server" {
  ami             = "ami-00a205cb8e06c3c4e"
  key_name        = "ssh_key_desktop"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet_public.id
  security_groups = [aws_security_group.ssh.id, aws_security_group.web_server.id]
  tags = {
    Name : "web_server"
    project : "terraform"
  }
  user_data  = file("webapp.sh")
  depends_on = [aws_internet_gateway.igw]
}

output "instance_dns_name" {
  description = "Instance DNS name"
  value = aws_instance.web_server.public_dns
}
