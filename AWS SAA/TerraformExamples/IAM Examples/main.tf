provider "aws" {
  region = var.region
}

# IAM Role for EC2/SSM
resource "aws_iam_role" "ssm_role" {
  name = var.ssm_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy" "kms_access" {
  name = "KMSAccess"
  role = aws_iam_role.ssm_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "kms:*",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.ssm_role_name}-profile"
  role = aws_iam_role.ssm_role.name
}

# IAM Group
resource "aws_iam_group" "group" {
  name = var.group_name
}

resource "aws_iam_group_policy_attachment" "group_policy" {
  group      = aws_iam_group.group.name
  policy_arn = var.group_policy_arn
}

# IAM User
resource "aws_iam_user" "user" {
  name = var.user_name
}

resource "aws_iam_user_group_membership" "user_group_membership" {
  user = aws_iam_user.user.name
  groups = [aws_iam_group.group.name]
}

resource "aws_iam_user_policy_attachment" "user_policy" {
  user       = aws_iam_user.user.name
  policy_arn = var.user_policy_arn
}

output "ssm_instance_profile" {
  value = aws_iam_instance_profile.ssm_profile.name
}

output "ssm_role_name" {
  value = aws_iam_role.ssm_role.name
}
