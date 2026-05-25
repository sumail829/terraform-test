data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "suman" {
  ami           = data.aws_ami.ubuntu.id
  subnet_id =  aws_subnet.main.id
  key_name =  aws_key_pair.suman-key.key_name
  root_block_device {
    volume_size = 32
  }
  vpc_security_group_ids = [aws_security_group.suman_sg.id]
    
  instance_type = "t3.medium"
associate_public_ip_address = true
  tags = {
    Name = "suman"
  }
}


resource "aws_security_group" "suman_sg" {
  name   = "suman_sg"
  vpc_id = aws_vpc.suman.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "suman_sg"
  }
}


resource "null_resource" "run_ansible" {
  depends_on = [
    aws_instance.suman,
    local_file.ansible_inventory
  ]
  provisioner "local-exec" {
    command     = "ansible-playbook -i inventory/inventory.ini setup.yaml"
    working_dir = "../ansible"
  }
}