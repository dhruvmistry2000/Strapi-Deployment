terraform {
  backend "s3" {
    bucket = "strapi-ecs"
    key = "terrafrom/terrafrom.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = var.region
}
