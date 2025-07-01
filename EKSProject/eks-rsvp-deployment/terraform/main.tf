terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  name    = var.vpc_name
  cidr    = var.vpc_cidr
  azs     = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true
  manage_aws_auth = true
  cluster_endpoint_public_access = true
  node_security_group_additional_rules = {
    ingress_allow_alb = {
      type        = "ingress"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Allow ALB to access RSVP app"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  eks_managed_node_groups = {}
}

# Karpenter IAM, OIDC, and Helm chart
module "karpenter" {
  source  = "terraform-aws-modules/eks/karpenter"
  cluster_name = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  oidc_provider_arn = module.eks.oidc_provider_arn
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  create_iam_role = true
  karpenter_node_role_name = "karpenter-rsvp-node"
  karpenter_controller_iam_role_name = "karpenter-rsvp-controller"
  karpenter_namespace = "karpenter"
  karpenter_service_account_name = "karpenter"
}

# ALB Controller
module "alb_controller" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-load-balancer-controller"
  cluster_name = module.eks.cluster_name
  cluster_identity_oidc_issuer = module.eks.cluster_oidc_issuer_url
  service_account_namespace = "kube-system"
  service_account_name = "aws-load-balancer-controller"
  vpc_id = module.vpc.vpc_id
  region = var.region
}

# API Gateway HTTP API to proxy to ALB
resource "aws_apigatewayv2_api" "rsvp" {
  name          = "rsvp-eks-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["*", "Content-Type"]
  }
}

resource "aws_apigatewayv2_integration" "rsvp_alb" {
  api_id                 = aws_apigatewayv2_api.rsvp.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = "http://${module.alb_controller.alb_dns}"
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "rsvp_proxy" {
  api_id    = aws_apigatewayv2_api.rsvp.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.rsvp_alb.id}"
}

resource "aws_apigatewayv2_stage" "rsvp_prod" {
  api_id      = aws_apigatewayv2_api.rsvp.id
  name        = "prod"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigw.arn
    format = jsonencode({
      requestId = "$context.requestId",
      ip = "$context.identity.sourceIp",
      requestTime = "$context.requestTime",
      httpMethod = "$context.httpMethod",
      routeKey = "$context.routeKey",
      status = "$context.status",
      protocol = "$context.protocol",
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_cloudwatch_log_group" "apigw" {
  name              = "/aws/apigateway/rsvp-eks-api"
  retention_in_days = 7
}

output "region" { value = var.region }
output "cluster_name" { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "vpc_id" { value = module.vpc.vpc_id }
output "alb_dns" { value = module.alb_controller.alb_dns }

# --- API Gateway HTTP API for RSVP Service ---
resource "aws_apigatewayv2_api" "rsvp_api" {
  name          = "rsvp-http-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["*", "Content-Type"]
  }
}

resource "aws_apigatewayv2_stage" "rsvp_stage" {
  api_id      = aws_apigatewayv2_api.rsvp_api.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.rsvp_api_logs.arn
    format = jsonencode({
      requestId       = "$context.requestId"
      ip              = "$context.identity.sourceIp"
      requestTime     = "$context.requestTime"
      httpMethod      = "$context.httpMethod"
      routeKey        = "$context.routeKey"
      status          = "$context.status"
      protocol        = "$context.protocol"
      responseLength  = "$context.responseLength"
    })
  }
}

resource "aws_cloudwatch_log_group" "rsvp_api_logs" {
  name              = "/aws/apigateway/rsvp-http-api"
  retention_in_days = 14
}

# ALB Listener ARN (assumes ALB controller creates an ALB for RSVP ingress)
data "aws_lb" "rsvp_alb" {
  name = module.alb_controller.alb_dns
}

data "aws_lb_listener" "rsvp_listener" {
  load_balancer_arn = data.aws_lb.rsvp_alb.arn
  port              = 80
}

resource "aws_apigatewayv2_integration" "rsvp_integration" {
  api_id           = aws_apigatewayv2_api.rsvp_api.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri  = data.aws_lb_listener.rsvp_listener.arn
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "rsvp_route" {
  api_id    = aws_apigatewayv2_api.rsvp_api.id
  route_key = "ANY /api/events/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.rsvp_integration.id}"
}

output "rsvp_api_endpoint" {
  value = aws_apigatewayv2_api.rsvp_api.api_endpoint
  description = "Invoke URL for RSVP API Gateway HTTP API"
}
