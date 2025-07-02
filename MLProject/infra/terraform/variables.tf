variable "aws_region" {
  description = "AWS region to deploy resources."
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for meal data."
  default     = "ml-example-meal-data-${random_id.suffix.hex}"
}

variable "sagemaker_image_uri" {
  description = "SageMaker training/inference image URI."
  default     = "<replace-with-your-ecr-image-uri>"
}

variable "model_artifact_url" {
  description = "S3 URL for trained model artifact."
  default     = "s3://ml-example-meal-data/model/model.tar.gz"
}
