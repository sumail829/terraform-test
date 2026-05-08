resource "tls_private_key" "rsa-4096-suman" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "suman-key" {
  key_name   = "suman-aws-key"
  public_key = tls_private_key.rsa-4096-suman.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.rsa-4096-suman.private_key_pem
  filename        = "${path.module}/../ansible/suman.pem" //path.module = current directry
  file_permission = "0400"
}