variable "group_name" {
  description = "Name of the IAM group"
  type        = string
}

variable "policy_arn" {
  description = "ARN of the policy to attach to the group"
  type        = string
}
