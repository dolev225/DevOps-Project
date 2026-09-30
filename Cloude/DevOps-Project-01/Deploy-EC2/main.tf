module "my_infrastructure" {

  source = "./Mode/"

  vpc_range     = "10.0.0.0/16"
  Subnet_count  = 2
  instance_type = "t3.micro"
  if_Public_ip  = true

}

output "ip_server" {
  description = "your ip form EC2 instance is"
  value       = module.my_infrastructure.ip_server
}
output "ssh_connection_command" {
  description = "Command to SSH into the EC2 instance"
  value       = "ssh -i 'test1.pem'  ec2-user@${module.my_infrastructure.ip_server}"
}