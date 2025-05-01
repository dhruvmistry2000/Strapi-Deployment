terraform {
  backend "s3" {
    bucket = "strapi-ecs"
    key = "terrafrom3/terrafrom.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}