data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_vpc" "my-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "mysubnet" {
  cidr_block = "192.168.1.0/24"
  vpc_id     = aws_vpc.my-vpc.id
  availability_zone = "eu-west-2a"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id
  ingress = [
    {
      description      = "SSH from my IP."
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${var.myip}/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = {
    Name = "allow_ssh_from_my_ip"
  }
  depends_on = [
    aws_vpc.my-vpc,
    aws_subnet.mysubnet]
}

resource "aws_key_pair" "key" {
  key_name   = "my-key-pair-tf"
  public_key = var.public_key
}

resource "aws_instance" "my-server" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.ec2_type
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = aws_key_pair.key.key_name
  subnet_id = aws_subnet.mysubnet.id
  associate_public_ip_address = true
  root_block_device {
    volume_size = 8
  }
  tags = {
    Name = var.ec2_name
  }
  depends_on = [
    aws_vpc.my-vpc,
    aws_security_group.allow_ssh,
    aws_key_pair.key,
    aws_subnet.mysubnet]
}