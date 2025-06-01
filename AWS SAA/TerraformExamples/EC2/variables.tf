variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
  default     = "ssh_key_pair_rj"
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "MySecurityGroup"
}

variable "security_group_description" {
  description = "Description of the security group"
  type        = string
  default     = "Security group for EC2 instance"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
  default     = "subnet-00fa9a101e58ac89e"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "MyEC2Instance"
}

variable "volume_size" {
  description = "Size of the root EBS volume in GiB"
  type        = number
  default     = 30
}

variable "volume_type" {
  description = "Type of the root EBS volume"
  type        = string
  default     = "gp2"
}

variable "kms_key_id" {
  description = "KMS Key ID for EBS volume encryption"
  type        = string
  default     = "kms_ec_key"
}

variable "vpc_id" {
  description = "The VPC ID to launch resources in"
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

variable "iam_instance_profile" {
  description = "IAM instance profile for EC2"
  type        = string
}