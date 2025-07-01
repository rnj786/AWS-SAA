#!/bin/bash
# Deploy API Gateway to proxy ALB for RSVP microservice
set -e
cd $(dirname $0)/..

# Use AWS CLI to create HTTP API Gateway with ALB integration
ALB_DNS=$(terraform -chdir=terraform output -raw alb_dns)
REGION=$(terraform -chdir=terraform output -raw region)

API_ID=$(aws apigatewayv2 create-api --name rsvp-eks-api --protocol-type HTTP --target "http://$ALB_DNS" --region $REGION --query 'ApiId' --output text)

aws apigatewayv2 create-integration --api-id $API_ID --integration-type HTTP_PROXY --integration-uri "http://$ALB_DNS" --payload-format-version 1.0 --region $REGION

aws apigatewayv2 create-route --api-id $API_ID --route-key "ANY /{proxy+}" --target integrations/$API_ID --region $REGION

aws apigatewayv2 create-stage --api-id $API_ID --stage-name prod --auto-deploy --region $REGION

echo "API Gateway deployed. API ID: $API_ID"
