#!/bin/bash

# Parameters
REGION="us-east-1"
INSTANCE_ID="i-03acfdbf1caee3c62" # Replace with the actual instance ID
SECURITY_GROUP_ID="sg-0399204af99ef5adc" # Replace with the actual security group ID
KEY_NAME="MyKeyPair"
KMS_KEY_ALIAS="alias/MyKMSKey"

# Terminate the EC2 Instance
echo "Terminating EC2 Instance: $INSTANCE_ID..."
aws ec2 terminate-instances --region $REGION --instance-ids $INSTANCE_ID
aws ec2 wait instance-terminated --region $REGION --instance-ids $INSTANCE_ID
echo "EC2 Instance terminated."

# Delete the Security Group
echo "Deleting Security Group: $SECURITY_GROUP_ID..."
aws ec2 delete-security-group --region $REGION --group-id $SECURITY_GROUP_ID
echo "Security Group deleted."

# Delete the Key Pair
echo "Deleting Key Pair: $KEY_NAME..."
rm -f ${KEY_NAME}.pem
aws ec2 delete-key-pair --region $REGION --key-name $KEY_NAME
echo "Key Pair deleted."

# Delete the KMS Key Alias
echo "Deleting KMS Key Alias: $KMS_KEY_ALIAS..."
aws kms delete-alias --region $REGION --alias-name $KMS_KEY_ALIAS
echo "KMS Key Alias deleted."

# Note: KMS keys cannot be deleted immediately. They are scheduled for deletion.
# Schedule the KMS Key for deletion
KMS_KEY_ID=$(aws kms describe-key --region $REGION --key-id $KMS_KEY_ALIAS --query 'KeyMetadata.KeyId' --output text)
echo "Scheduling KMS Key for deletion: $KMS_KEY_ID..."
aws kms schedule-key-deletion --region $REGION --key-id $KMS_KEY_ID --pending-window-in-days 7
echo "KMS Key scheduled for deletion in 7 days."

echo "Resource cleanup completed."