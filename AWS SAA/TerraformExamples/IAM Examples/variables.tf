variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "role_name" {
  description = "Name of the IAM role"
  type        = string
  default     = "TFRole"
}

variable "group_name" {
  description = "Name of the IAM group"
  type        = string
  default     = "EC2TFModerator"
}

variable "user_name" {
  description = "Name of the IAM user"
  type        = string
  default     = "TFUser"
}
