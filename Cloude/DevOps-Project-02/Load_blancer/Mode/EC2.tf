locals {
  servers = [
    {
      name           = "bear-server"
      title          = "Bear Server"
      color          = "#2e4053"
      image_base_url = "https://placebear.com"
      image_file     = "500/400"
    },
    {
      name           = "deer-server"
      title          = "Deer Server"
      color          = "#1e8449"
      image_base_url = "https://images.unsplash.com"
      image_file     = "photo-1484406566174-9da000fda645?w=500&q=80"
    }
  ]
}

resource "aws_instance" "web-ec2" {
  count = length(local.servers)

  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = element(aws_subnet.subnet_instans[*].id, count.index)
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/scripts/html.sh", {
    title          = local.servers[count.index].title
    color          = local.servers[count.index].color
    image_base_url = local.servers[count.index].image_base_url
    image_file     = local.servers[count.index].image_file
  })

  tags = {
    Name = "${var.project_name}-${local.servers[count.index].name}"
  }
}