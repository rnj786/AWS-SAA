variable "region" {
  description = "AWS region"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "volume_size" {
  description = "Size of the root EBS volume in GiB"
  type        = number
}

variable "volume_type" {
  description = "Type of the root EBS volume"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to launch resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM instance profile for EC2"
  type        = string
}

variable "ssm_role_name" {
  description = "Name of the SSM IAM role for EC2"
  type        = string
}

variable "user_name" {
  description = "Name of the IAM user"
  type        = string
}

variable "group_name" {
  description = "Name of the IAM group"
  type        = string
}

variable "user_policy_arn" {
  description = "Policy ARN to attach to the IAM user"
  type        = string
}

variable "group_policy_arn" {
  description = "Policy ARN to attach to the IAM group"
  type        = string
}

variable "additional_ebs_device_name" {
  description = "Device name for the additional EBS volume (e.g., /dev/xvdb)"
  type        = string
  default     = "/dev/xvdb"
}

variable "additional_ebs_volume_size" {
  description = "Size of the additional EBS volume in GB"
  type        = number
  default     = 10
}

variable "additional_ebs_volume_type" {
  description = "Type of the additional EBS volume"
  type        = string
  default     = "gp3"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}