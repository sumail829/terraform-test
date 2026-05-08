output "instance_public_ip" {
  value       = aws_instance.suman.public_ip
  description = "public ip of ec2 instance"
}
resource "local_file" "ansible_inventory" {
  content  = <<EOT
[vm]
${aws_instance.suman.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=suman.pem
EOT
  filename = "${path.module}/../ansible/inventory/inventory.ini"
}