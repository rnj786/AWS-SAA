#!/bin/bash

# Parameters
REGION="us-east-1"
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
KEY_NAME="MyKeyPair"
SECURITY_GROUP_NAME="MySecurityGroup"
SECURITY_GROUP_DESC="Security group for EC2 instance"
KMS_KEY_ALIAS="alias/MyKMSKey"
VOLUME_SIZE=8 # Size in GiB
VOLUME_TYPE="gp2" # General Purpose SSD

# Create a KMS Key
echo "Creating KMS Key..."
KMS_KEY_ID=$(aws kms create-key --region $REGION --query 'KeyMetadata.KeyId' --output text)
aws kms create-alias --region $REGION --alias-name $KMS_KEY_ALIAS --target-key-id $KMS_KEY_ID
echo "KMS Key created with ID: $KMS_KEY_ID"

# Create a Security Group
echo "Creating Security Group..."
SECURITY_GROUP_ID=$(aws ec2 create-security-group --region $REGION --group-name $SECURITY_GROUP_NAME --description "$SECURITY_GROUP_DESC" --query 'GroupId' --output text)
echo "Security Group created with ID: $SECURITY_GROUP_ID"

# Add a rule to allow SSH access
aws ec2 authorize-security-group-ingress --region $REGION --group-id $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
echo "Added SSH access rule to Security Group."

# Create a Key Pair
echo "Creating Key Pair..."
aws ec2 create-key-pair --region $REGION --key-name $KEY_NAME --query 'KeyMaterial' --output text > ${KEY_NAME}.pem
chmod 400 ${KEY_NAME}.pem
echo "Key Pair created and saved to ${KEY_NAME}.pem"

# Create an EC2 Instance with an encrypted EBS volume
echo "Launching EC2 Instance..."
INSTANCE_ID=$(aws ec2 run-instances \
    --region $REGION \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SECURITY_GROUP_ID \
    --block-device-mappings "[{\"DeviceName\":\"/dev/xvda\",\"Ebs\":{\"VolumeSize\":$VOLUME_SIZE,\"VolumeType\":\"$VOLUME_TYPE\",\"Encrypted\":true,\"KmsKeyId\":\"$KMS_KEY_ID\"}}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "EC2 Instance launched with ID: $INSTANCE_ID"

# Wait for the instance to be in running state
echo "Waiting for the instance to reach 'running' state..."
aws ec2 wait instance-running --region $REGION --instance-ids $INSTANCE_ID
echo "Instance is now running."

# Output instance details
aws ec2 describe-instances --region $REGION --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0]' --output json

echo "Instance details:"
aws ec2 describe-instances --region $REGION --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0]' --output table
echo "EC2 Instance with encrypted EBS volume has been successfully created."



echo "You can now connect to your EC2 instance using the following command:"
echo "ssh -i ${KEY_NAME}.pem ec2-user@<Public-IP-Address>"
echo "Replace <Public-IP-Address> with the actual public IP address of your EC2 instance."
echo "You can find the public IP address in the instance details above."


echo "Remember to clean up resources after use."

# Clean up resources
echo "Cleaning up resources..."
aws ec2 terminate-instances --region $REGION --instance-ids $INSTANCE_ID
aws ec2 delete-security-group --region $REGION --group-id $SECURITY_GROUP_ID
aws kms delete-alias --region $REGION --alias-name $KMS_KEY_ALIAS
aws kms schedule-key-deletion --region $REGION --key-id $KMS_KEY_ID --pending-window-in-days 7
echo "Resources cleaned up."
echo "Script completed."
echo "Remember to delete the key pair file ${KEY_NAME}.pem if not needed."
echo "Script execution completed."

# echo "Thank you for using this script!"     