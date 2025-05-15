#!/bin/bash

# Configuration variables
ROLE_NAME="TFRole"
GROUP_NAME="EC2TFModerator"
USER_NAME="TFUser"
POLICY_DOCUMENT='{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}'

# Create IAM Role
echo "Creating IAM Role: $ROLE_NAME"
aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document "$POLICY_DOCUMENT"

# Create IAM Group
echo "Creating IAM Group: $GROUP_NAME"
aws iam create-group --group-name "$GROUP_NAME"

# Create IAM User
echo "Creating IAM User: $USER_NAME"
aws iam create-user --user-name "$USER_NAME"

# Attach User to Group
echo "Adding user $USER_NAME to group $GROUP_NAME"
aws iam add-user-to-group --group-name "$GROUP_NAME" --user-name "$USER_NAME"

# Uncomment the following lines to delete resources
echo "Deleting resources..."
aws iam remove-user-from-group --group-name "$GROUP_NAME" --user-name "$USER_NAME"
aws iam delete-user --user-name "$USER_NAME"
aws iam delete-group --group-name "$GROUP_NAME"
aws iam delete-role --role-name "$ROLE_NAME"

echo "Script execution completed."