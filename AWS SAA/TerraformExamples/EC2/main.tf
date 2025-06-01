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
  vpc_id      = var.vpc_id  # <-- This will be passed from the root module

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

// User data script to install Java, CIS hardening, Node.js, and Python 3
data "template_file" "custom_ami_userdata" {
  template = <<-EOF
    #!/bin/bash
    yum update -y

    # Install Java (Amazon Corretto 11)
    amazon-linux-extras install java-openjdk11 -y

    # Install CIS hardening tool (example: Amazon Inspector, or you can use a CIS script)
    # For demonstration, we'll just echo a placeholder
    echo "CIS hardening would be applied here" > /etc/cis_hardening.txt

    # Install Node.js
    curl -sL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs

    # Install Python 3
    yum install -y python3

    # Clean up
    yum clean all
  EOF
}

// Launch a temporary EC2 instance to create the custom AMI
resource "aws_instance" "custom_ami_builder" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.key_pair.key_name

  user_data              = data.template_file.custom_ami_userdata.rendered

  tags = {
    Name = "CustomAMIBuilder"
  }

  root_block_device {
    volume_size           = 16
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = aws_kms_key.ebs_kms_key.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Create a custom AMI from the instance
resource "aws_ami_from_instance" "custom_ami" {
  name               = "globalencounters-custom-ami"
  source_instance_id = aws_instance.custom_ami_builder.id
  depends_on         = [aws_instance.custom_ami_builder]

  tags = {
    Name = "Custom Amazon Linux 2 AMI with Java, CIS, Node.js, Python3"
  }
}


// Create an EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami                    = aws_ami_from_instance.custom_ami.id   # <-- Use the custom AMI created above
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = var.private_subnet_ids[0]  # Use the first public subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile    = var.iam_instance_profile

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

  # Additional EBS volume
  ebs_block_device {
    device_name           = var.additional_ebs_device_name   # e.g., "/dev/xvdb"
    volume_size           = var.additional_ebs_volume_size
    volume_type           = var.additional_ebs_volume_type
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = aws_kms_key.ebs_kms_key.arn
  }
}
