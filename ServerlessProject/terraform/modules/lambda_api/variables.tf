variable "lambda_bucket_arn" {
  description = "ARN of the S3 bucket where the Lambda deployment package (zip file) is stored."
  type        = string
  default      ="arn:aws:s3:::file-manager-lambda-abcd1234"
}

variable "lambda_bucket_name" {
  description = "Name of the S3 bucket where the Lambda deployment package (zip file) is stored."
  type        = string
  default      ="file-manager-lambda-abcd1234"
}

variable "lambda_s3_key" {
  description = "S3 key for the Lambda deployment package (zip file)."
  default      ="lambda/python_lambda.zip"
}

variable "lambda_runtime" {
  description = "Lambda runtime (e.g., python3.11, nodejs18.x, provided.al2)."
  type        = string
  default     = "python3.11"
}

variable "lambda_handler" {
  description = "Lambda handler (e.g., lambda_function.lambda_handler for Python)."
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda in MB."
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Timeout for Lambda in seconds."
  type        = number
  default     = 30
}

variable "lambda_env_vars" {
  description = "Environment variables for Lambda. Should include BUCKET (the S3 bucket name, e.g., 'file-manager-files-xxxx') for the Python Lambda to access the S3 files bucket."
  type        = map(string)
  default     = {
    BUCKET = "file-manager-files-abcd1234"
  }
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

# Note: Update references in the rest of the code from files_bucket_arn and files_bucket_name to lambda_bucket_arn and lambda_bucket_name accordingly.
