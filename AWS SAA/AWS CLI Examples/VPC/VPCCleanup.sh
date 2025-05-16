#!/bin/bash

# Parameters
REGION=${1:-us-east-1}
CSV_FILE="VPCResources.csv"

# Ensure the CSV file exists
if [[ ! -f $CSV_FILE ]]; then
  echo "CSV file $CSV_FILE not found. Ensure the file exists and contains the resource IDs."
  exit 1
fi

# Read resource IDs from the CSV file
VPC_ID=$(grep "VPC" $CSV_FILE | cut -d ',' -f2)
IGW_ID=$(grep "InternetGateway" $CSV_FILE | cut -d ',' -f2)
PUBLIC_SUBNET_ID=$(grep "PublicSubnet" $CSV_FILE | cut -d ',' -f2)
PRIVATE_SUBNET_ID=$(grep "PrivateSubnet" $CSV_FILE | cut -d ',' -f2)
PUBLIC_RT_ID=$(grep "PublicRouteTable" $CSV_FILE | cut -d ',' -f2)
PRIVATE_RT_ID=$(grep "PrivateRouteTable" $CSV_FILE | cut -d ',' -f2)
NAT_GW_ID=$(grep "NATGateway" $CSV_FILE | cut -d ',' -f2)
EIP_ALLOC_ID=$(grep "ElasticIP" $CSV_FILE | cut -d ',' -f2)

# Ensure all required variables are set
if [[ -z "$VPC_ID" || -z "$IGW_ID" || -z "$PUBLIC_SUBNET_ID" || -z "$PRIVATE_SUBNET_ID" || -z "$PUBLIC_RT_ID" || -z "$PRIVATE_RT_ID" || -z "$NAT_GW_ID" || -z "$EIP_ALLOC_ID" ]]; then
  echo "One or more required resource IDs are missing in the CSV file. Ensure the file contains all necessary IDs."
  exit 1
fi

# Delete NAT Gateway
echo "Deleting NAT Gateway: $NAT_GW_ID..."
aws ec2 delete-nat-gateway --nat-gateway-id $NAT_GW_ID --region $REGION
aws ec2 wait nat-gateway-deleted --nat-gateway-ids $NAT_GW_ID --region $REGION
echo "NAT Gateway deleted."

# Release Elastic IP
echo "Releasing Elastic IP: $EIP_ALLOC_ID..."
aws ec2 release-address --allocation-id $EIP_ALLOC_ID --region $REGION
echo "Elastic IP released."

# Disassociate and delete route tables
echo "Disassociating and deleting route tables..."
aws ec2 disassociate-route-table --association-id $(aws ec2 describe-route-tables --region $REGION --filters "Name=route-table-id,Values=$PUBLIC_RT_ID" --query 'RouteTables[0].Associations[0].RouteTableAssociationId' --output text)
aws ec2 delete-route-table --route-table-id $PUBLIC_RT_ID --region $REGION
echo "Public Route Table deleted."

aws ec2 disassociate-route-table --association-id $(aws ec2 describe-route-tables --region $REGION --filters "Name=route-table-id,Values=$PRIVATE_RT_ID" --query 'RouteTables[0].Associations[0].RouteTableAssociationId' --output text)
aws ec2 delete-route-table --route-table-id $PRIVATE_RT_ID --region $REGION
echo "Private Route Table deleted."

# Delete subnets
echo "Deleting subnets..."
aws ec2 delete-subnet --subnet-id $PUBLIC_SUBNET_ID --region $REGION
echo "Public Subnet deleted."

aws ec2 delete-subnet --subnet-id $PRIVATE_SUBNET_ID --region $REGION
echo "Private Subnet deleted."

# Detach and delete Internet Gateway
echo "Detaching and deleting Internet Gateway: $IGW_ID..."
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID --region $REGION
echo "Internet Gateway deleted."

# Delete VPC
echo "Deleting VPC: $VPC_ID..."
aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION
echo "VPC deleted."

echo "Cleanup completed successfully."