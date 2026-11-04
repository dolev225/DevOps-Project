variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "Subnet_count" {
  type    = number
  default = 2
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "if_Public_ip" {
  type    = bool
  default = true
}

variable "docker_image" {
  type        = string
  default     = "dolev1234/cloud-app:v1.6"
  description = "The Docker image to pull and run on the EC2 instances"
}