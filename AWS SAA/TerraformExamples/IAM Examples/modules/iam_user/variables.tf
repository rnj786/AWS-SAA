variable "user_name" {
  description = "Name of the IAM user"
  type        = string
}

variable "group_name" {
  description = "Name of the IAM group to assign the user to"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role to assign to the user"
  type        = string
}
