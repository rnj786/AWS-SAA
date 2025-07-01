#!/bin/bash
# Usage: ./push-to-ecr.sh [region] [repository_name] [tag]
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=${1:-us-west-2}
REPO_NAME=${2:-eventrsvp}
TAG=${3:-1.2}

if [ -z "$AWS_ACCOUNT_ID" ] || [ "$AWS_ACCOUNT_ID" == "None" ]; then
  echo "Could not determine AWS account ID. Please ensure you are logged in with AWS CLI."
  exit 1
fi

# Authenticate Docker to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Create ECR repository if it doesn't exist
if ! aws ecr describe-repositories --repository-names $REPO_NAME --region $REGION > /dev/null 2>&1; then
  aws ecr create-repository --repository-name $REPO_NAME --region $REGION
fi

# Build Docker image
./build.sh
docker build -t $REPO_NAME:$TAG .

docker tag $REPO_NAME:$TAG $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$TAG

docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$TAG



# Output the container image URL for Terraform
IMAGE_URL="$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:$TAG"
echo "Container image URL: $IMAGE_URL"
echo $IMAGE_URL > image_url.txt
