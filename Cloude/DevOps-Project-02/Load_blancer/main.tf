module "my_infrastructure" {

  source = "./Mode/"

  vpc_range     = "10.0.0.0/16"
  Subnet_count  = 2
  instance_type = "t3.micro"
  if_Public_ip  = true

}


output "application_url" {
  description = "URL to test the load balancer"
  value       = module.my_infrastructure.application_url
}