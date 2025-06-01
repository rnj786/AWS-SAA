variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "policy_arn" {
  description = "ARN of the policy to attach to the role"
  type        = string
}

variable "ssm_role_name" {
  description = "Name for the SSM IAM role"
  type        = string
  default     = "ec2_ssm_role"
}
