variable "region" { type = string }
variable "frontend_bucket_acl" { type = string; default = "public-read" }
variable "frontend_index_document" { type = string; default = "index.html" }
variable "frontend_error_document" { type = string; default = "index.html" }
variable "files_bucket_acl" { type = string; default = "private" }
variable "lambda_s3_key" { type = string }
variable "lambda_runtime" { type = string; default = "provided.al2" }
variable "lambda_handler" { type = string; default = "not.used" }
variable "lambda_memory_size" { type = number; default = 512 }
variable "lambda_timeout" { type = number; default = 30 }
variable "lambda_env_vars" { type = map(string); default = {} }
variable "tags" { type = map(string); default = {} }
variable "python_lambda_s3_key" {
  description = "S3 key for the Python Lambda deployment package."
  type        = string
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda functions."
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Timeout for Lambda functions."
  type        = number
  default     = 30
}
