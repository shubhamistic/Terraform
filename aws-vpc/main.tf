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

# Create a VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

# Create a Private Subnet
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "private-subnet"
  }
}

# Create a Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "public-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-igw"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "my-rt"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.my-rt.id
}

resource "aws_instance" "myserver" {
  ami = "ami-00ca570c1b6d79f36"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public-subnet.id

  tags = {
    Name = "SampleServer"
  }
}