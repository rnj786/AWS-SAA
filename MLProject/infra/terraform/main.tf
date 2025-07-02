# Terraform for MLExample: S3, SageMaker, and API Gateway

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "meal_data" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

resource "aws_sagemaker_role" "execution_role" {
  name = "ml-example-sagemaker-execution-role"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_role.json
}

data "aws_iam_policy_document" "sagemaker_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "sagemaker_s3_access" {
  role       = aws_sagemaker_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_sagemaker_model" "meal_recommender" {
  name               = "meal-recommender-model"
  execution_role_arn = aws_sagemaker_role.execution_role.arn
  primary_container {
    image = var.sagemaker_image_uri
    model_data_url = var.model_artifact_url
  }
}

resource "aws_sagemaker_endpoint_configuration" "meal_recommender_config" {
  name = "meal-recommender-config"
  production_variants {
    variant_name           = "AllTraffic"
    model_name             = aws_sagemaker_model.meal_recommender.name
    initial_instance_count = 1
    instance_type          = "ml.m5.large"
  }
}

resource "aws_sagemaker_endpoint" "meal_recommender_endpoint" {
  name                 = "meal-recommender-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.meal_recommender_config.name
}

resource "aws_apigatewayv2_api" "meal_api" {
  name          = "meal-recommendation-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "OPTIONS"]
    allow_headers = ["*"]
  }
}

# Outputs
output "s3_bucket_name" { value = aws_s3_bucket.meal_data.bucket }
output "sagemaker_endpoint_name" { value = aws_sagemaker_endpoint.meal_recommender_endpoint.name }
output "api_gateway_url" { value = aws_apigatewayv2_api.meal_api.api_endpoint }
