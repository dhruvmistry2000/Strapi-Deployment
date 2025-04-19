variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0fc5d935ebf8bc3bc" 
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.medium" 
}

variable "image_uri" {
  description = "URI of the Docker image to deploy"
  default     = "dhruvmistry200/strapi-app:latest"
}
variable "key_name" {
  description = "Key-pair name for SSH access to the instance"
  default     = "starpi-app"
}