terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }
  backend "s3" {
    bucket = "aws-s3-bucket-540b1f0d2aca595c"
    key = "backend.tfstate"
    region = "ap-south-1"
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