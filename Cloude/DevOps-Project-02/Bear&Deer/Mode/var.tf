variable "vpc_range" {
  default = "10.0.0.0/16"
  type= string
}
variable "Subnet_count" {
  default = 2
  type=string
}
variable "instance_type" {
  default = "t2.micro"
}
variable "if_Public_ip" {
  default = true
  type = bool
}
variable "ami" {
  default = "ami-0fef201115eefe936" 
  type = string
}
variable "availability_zone" {
  default = "us-east-1a"
  type = string
}

variable "image_base_url" {
  description = "Public base URL where bear.jpg and deer.jpg are hosted (raw GitHub URL of the images folder)"
  type        = string
  default     = "https://raw.githubusercontent.com/dolev225/DevOps-Project/main/Cloude/DevOps-Project-02/Load-Balancer/images"
}

variable "project_name" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "lb-demo"
}