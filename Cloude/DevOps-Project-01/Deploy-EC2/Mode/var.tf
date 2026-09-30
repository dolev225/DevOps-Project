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