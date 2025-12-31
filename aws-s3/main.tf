terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_id" "random-id" {
  byte_length = 8
}

resource "aws_s3_bucket" "aws-s3-bucket" {
  bucket = "aws-s3-bucket-${random_id.random-id.hex}"
}

resource "aws_s3_object" "aws-s3-bucket-data" {
  bucket = aws_s3_bucket.aws-s3-bucket.bucket
  source = "./sample-upload-file.txt"
  key = "sample-uploaded-file.txt"
}