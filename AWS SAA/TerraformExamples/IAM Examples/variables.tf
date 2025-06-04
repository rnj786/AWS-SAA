variable "region" {
  description = "AWS region"
  type        = string
}

variable "ssm_role_name" {
  description = "Name for the SSM IAM role"
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
