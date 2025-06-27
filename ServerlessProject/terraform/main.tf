provider "aws" {
  region = var.region
}

resource "random_id" "suffix" {
  byte_length = 4
}

module "s3" {
  source                  = "./modules/s3"
  random_id_suffix        = random_id.suffix.hex
  frontend_bucket_acl     = var.frontend_bucket_acl
  frontend_index_document = var.frontend_index_document
  frontend_error_document = var.frontend_error_document
  files_bucket_acl        = var.files_bucket_acl
  tags                   = var.tags
}

module "lambda_api" {
  source                = "./modules/lambda_api"
  files_bucket_arn      = module.s3.files_bucket_name
  files_bucket_name     = module.s3.files_bucket_name
  lambda_s3_key         = var.lambda_s3_key
  lambda_runtime        = var.lambda_runtime
  lambda_handler        = var.lambda_handler
  lambda_memory_size    = var.lambda_memory_size
  lambda_timeout        = var.lambda_timeout
  lambda_env_vars       = var.lambda_env_vars
  tags                 = var.tags
}

module "python_lambda_api" {
  source                = "../modules/lambda_api"
  files_bucket_arn      = module.s3.files_bucket_name
  files_bucket_name     = module.s3.files_bucket_name
  lambda_s3_key         = var.python_lambda_s3_key
  lambda_runtime        = "python3.11"
  lambda_handler        = "lambda_function.lambda_handler"
  lambda_memory_size    = var.lambda_memory_size
  lambda_timeout        = var.lambda_timeout
  lambda_env_vars       = {
    BUCKET = module.s3.files_bucket_name
  }
  tags                 = var.tags
}

output "frontend_bucket_name" { value = module.s3.frontend_bucket_name }
output "files_bucket_name"    { value = module.s3.files_bucket_name }
output "api_url"              { value = module.lambda_api.api_url }
output "lambda_function_name" { value = module.lambda_api.lambda_function_name }
