resource "aws_instance" "test1" {
    ami      = var.ami
    instance_type = var.instance_type
    key_name      = "test1"

    subnet_id                   = aws_subnet.subnet_instans.id
    vpc_security_group_ids      = [aws_security_group.sg1.id]
    associate_public_ip_address = var.if_Public_ip

    user_data                   = file("${path.module}/screp.sh")
    tags = {
      Name = "test1"
    }
}