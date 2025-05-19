provider "aws" {
  region = var.region
}

// Create a KMS Key
resource "aws_kms_key" "ebs_kms_key" {
  description             = "KMS key for encrypting EBS volumes"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

// Create a Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

// Create a Security Group
resource "aws_security_group" "ec2_sg" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Create an EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  tags = {
    Name = var.instance_name
  }

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = aws_kms_key.ebs_kms_key.arn
  }
}
