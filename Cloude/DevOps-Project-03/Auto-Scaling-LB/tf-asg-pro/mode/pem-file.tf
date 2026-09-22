# key type
resource "tls_private_key" "dolev_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# aws -set key
resource "aws_key_pair" "deployer_key" {
  key_name   = "CPU-sterss-key" 
  public_key = tls_private_key.dolev_key_pair.public_key_openssh
}

# save the file on the pc
resource "local_file" "save_key" {
  content  = tls_private_key.dolev_key_pair.private_key_pem
  filename = "${path.module}/keys/CPU-sterss-key.pem"
}