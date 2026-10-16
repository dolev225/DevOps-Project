module "my_infrastructure" {

  source = "./mode/"

  vpc_range     = "10.0.0.0/16"
  Subnet_count  = 2
  instance_type = "t3.micro"
  if_Public_ip  = true

}

output "load_balancer_address" {
  value = module.my_infrastructure.alb_dns_name
}
