terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "name" {
  most_recent = true
  owners = ["amazon"]
}

output "aws_ami" {
  value = data.aws_ami.name.id
}

# security group
resource "aws_security_group" "name" {
  tags = {
    mysg = "http"
  }
}

output "security_group" {
  value = aws_security_group.name
}
    
resource "aws_instance" "myserver" {
  ami = data.aws_ami.name.id
  instance_type = "t3.micro"

  tags = {
    Name = "SampleServer"
  }
}