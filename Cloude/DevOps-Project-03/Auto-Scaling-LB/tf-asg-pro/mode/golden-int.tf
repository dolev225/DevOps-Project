resource "aws_launch_template" "golden_machin_template" {
  name_prefix   = "golden_machin"
  image_id      = "ami-0ea87431b78a82070" 
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer_key.key_name

  network_interfaces {
    associate_public_ip_address = var.if_Public_ip
    security_groups             = [aws_security_group.CPU_stress_sg.id]
  }

  user_data = base64encode(file("${path.module}/install_app.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Golden-Server-Node"
    }
  }
}