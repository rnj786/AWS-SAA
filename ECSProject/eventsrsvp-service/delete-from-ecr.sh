#!/bin/bash
# Usage: ./delete-from-ecr.sh [region] [repository_name] [tag]
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION=${1:-us-west-2}
REPO_NAME=${2:-eventrsvp}
TAG=${3:-1.0}

if [ -z "$AWS_ACCOUNT_ID" ] || [ "$AWS_ACCOUNT_ID" == "None" ]; then
  echo "Could not determine AWS account ID. Please ensure you are logged in with AWS CLI."
  exit 1
fi

# Delete the image from ECR
aws ecr batch-delete-image \
  --region $REGION \
  --repository-name $REPO_NAME \
  --image-ids imageTag=$TAG

if [ $? -eq 0 ]; then
  echo "Deleted $REPO_NAME:$TAG from $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME"
else
  echo "Failed to delete image."
fi
