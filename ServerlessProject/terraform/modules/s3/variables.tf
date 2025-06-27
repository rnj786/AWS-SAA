variable "random_id_suffix" {
  description = "Random suffix for bucket names to ensure uniqueness."
  type        = string
}

variable "frontend_bucket_acl" {
  description = "Canned ACL to apply to the frontend S3 bucket."
  type        = string
  default     = "public-read"
}

variable "frontend_index_document" {
  description = "Index document for the frontend S3 website."
  type        = string
  default     = "index.html"
}

variable "frontend_error_document" {
  description = "Error document for the frontend S3 website."
  type        = string
  default     = "index.html"
}

variable "files_bucket_acl" {
  description = "Canned ACL to apply to the files S3 bucket."
  type        = string
  default     = "private"
}

variable "lambda_bucket_acl" {
  description = "Canned ACL to apply to the Lambda S3 bucket."
  type        = string
  default     = "private"
}

variable "tags" {
  description = "Tags to apply to all S3 resources."
  type        = map(string)
  default     = {}
}

variable "files_bucket_policy_principal" {
  description = "Principal ARN allowed to perform CRUD operations on the files bucket."
  type        = string
  default     = "arn:aws:sts::054116116033:assumed-role/file-manager-lambda-role/file-manager"
}
