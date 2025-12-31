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

resource "aws_s3_bucket" "webapp-bucket" {
  bucket = "aws-s3-bucket-${random_id.random-id.hex}"
}

resource "aws_s3_bucket_public_access_block" "webapp-bucket-block" {
  bucket = aws_s3_bucket.webapp-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "webapp-bucket-policy" {
  bucket = aws_s3_bucket.webapp-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",		 	 	 
      Statement = [
        {
          Sid = "PublicReadGetObject",
          Effect = "Allow",
          Principal = "*",
          Action = [
            "s3:GetObject"
          ],
          Resource = [
            "arn:aws:s3:::${aws_s3_bucket.webapp-bucket.id}/*"
          ]
        }
      ]
    }
  )
} 

resource "aws_s3_bucket_website_configuration" "webapp-bucket-website" {
  bucket = aws_s3_bucket.webapp-bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index-html" {
  bucket = aws_s3_bucket.webapp-bucket.bucket
  source = "./index.html"
  key = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "styles-css" {
  bucket = aws_s3_bucket.webapp-bucket.bucket
  source = "./styles.css"
  key = "styles.css"
  content_type = "text/css"
}

output "name" {
  value = aws_s3_bucket_website_configuration.webapp-bucket-website.website_endpoint
}