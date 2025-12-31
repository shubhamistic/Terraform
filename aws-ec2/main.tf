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

resource "aws_instance" "myserver" {
  ami = "ami-00ca570c1b6d79f36"
  instance_type = "t3.micro"

  tags = {
    Name = "SampleServer"
  }
}