variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ssm_role_name" {
  description = "Name for the SSM IAM role"
  type        = string
  default     = "ec2_ssm_role"
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

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "main-vpc"
}

variable "user_name" {
  description = "Name of the IAM user"
  type        = string
  default     = "my-iam-user"
}

variable "group_name" {
  description = "Name of the IAM group"
  type        = string
  default     = "my-iam-group"
}

variable "user_policy_arn" {
  description = "Policy ARN to attach to the IAM user"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

variable "group_policy_arn" {
  description = "Policy ARN to attach to the IAM group"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "054116116033"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "GES3Bucket-1"
}

variable "s3_force_destroy" {
  description = "Force destroy the bucket on deletion"
  type        = bool
  default     = false
}

variable "s3_versioning_enabled" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = false
}

variable "s3_sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "s3_kms_key_id" {
  description = "KMS Key ID for SSE-KMS encryption (if used)"
  type        = string
  default     = null
}

variable "s3_block_public_acls" {
  description = "Block public ACLs?"
  type        = bool
  default     = true
}

variable "s3_block_public_policy" {
  description = "Block public bucket policies?"
  type        = bool
  default     = true
}

variable "s3_ignore_public_acls" {
  description = "Ignore public ACLs?"
  type        = bool
  default     = true
}

variable "s3_restrict_public_buckets" {
  description = "Restrict public buckets?"
  type        = bool
  default     = true
}

variable "s3_tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}