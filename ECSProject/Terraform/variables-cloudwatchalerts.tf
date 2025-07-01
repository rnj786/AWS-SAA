variable "cloudwatchalerts_email" {
  description = "Email address to receive CloudWatch alert notifications for API Gateway."
  type        = string
  default      = "rnj786@gmail.com"
}


variable "cloudwatchalerts_threshold" {
  description = "Threshold for API Gateway request count alarm."
  type        = number
  default     = 1
}
