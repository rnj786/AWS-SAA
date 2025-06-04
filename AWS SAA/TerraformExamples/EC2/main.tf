provider "aws" {
  region = var.region
}

// Create a KMS Key
resource "aws_kms_key" "ebs_kms_key" {
  description             = "KMS key for encrypting EBS volumes"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-updated",
    Statement = [
      {
        Sid      = "Allow administration of the key",
        Effect   = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid      = "Allow EC2 and ASG role to use the key",
        Effect   = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:role/${var.ssm_role_name}"
        },
        Action = [
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ],
        Resource = "*"
      },
      {
        Sid      = "Allow EC2 service to use the key",
        Effect   = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = [
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ],
        Resource = "*"
      },
      {
        Sid      = "Allow Auto Scaling Service Role to use the key",
        Effect   = "Allow",
        Principal = {
          AWS = "arn:aws:iam::054116116033:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        Action = [
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ],
        Resource = "*"
      }
    ]
  })
}

// Create a Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

// Create a EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  # Allow SSH from allowed CIDR
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # Allow HTTP from internal (VPC CIDR or private subnets)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    # Replace with your VPC CIDR or private subnet CIDRs for internal traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    security_groups          = [aws_security_group.alb_sg.id]
  }

  # Allow 8080 from external (anywhere)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
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
  template = base64encode(<<-EOF
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1
    set -ex

    # Wait for networking
    until ping -c1 amazon.com &>/dev/null; do
      echo "Waiting for network..."
      sleep 3
    done

    yum update -y
    yum install -y httpd

    # Change default port from 80 to 8080
    sed -i 's/^Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
    sed -i 's_:80_:8080_g' /etc/httpd/conf/httpd.conf

    systemctl enable httpd
    systemctl start httpd

    echo "<h1>Hello from Terraform EC2 User Data!</h1>" > /var/www/html/index.html
  EOF
  )
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

# --- Launch Template using the custom AMI ---
resource "aws_launch_template" "custom_lt" {
  name_prefix   = "custom-ami-lt-"
  image_id      = aws_ami_from_instance.custom_ami.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  user_data              = data.template_file.custom_ami_userdata.rendered
  iam_instance_profile {
    name = var.iam_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.ebs_kms_key.arn
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.instance_name}-lt"
    }
  }
}

# --- Application Load Balancer (ELB) ---
resource "aws_lb" "app_lb" {
  name               = "custom-app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids

  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "app_tg" {
  name     = "custom-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "8080"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# --- Auto Scaling Group with Mixed Instances Policy ---
resource "aws_autoscaling_group" "custom_asg" {
  name                      = "custom-asg"
  min_size                  = 0
  max_size                  = 3
  desired_capacity          = 1
  vpc_zone_identifier       = var.private_subnet_ids

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.custom_lt.id
        version            = "$Latest"
      }
    }

    instances_distribution {
      on_demand_percentage_above_base_capacity = 20
      spot_allocation_strategy                 = "capacity-optimized"
    }
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]
  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "${var.instance_name}-asg"
    propagate_at_launch = true
  }
}
