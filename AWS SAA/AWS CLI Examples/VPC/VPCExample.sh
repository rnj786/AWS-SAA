#!/bin/bash

# Parameters
VPC_NAME=${1:-MyVPC}
CIDR_BLOCK=${2:-10.0.0.0/16}
PUBLIC_SUBNET_CIDR=${3:-10.0.1.0/24}
PRIVATE_SUBNET_CIDR=${4:-10.0.2.0/24}
REGION=${5:-us-east-1}

# Create VPC
# A Virtual Private Cloud (VPC) is a logically isolated network in AWS.
VPC_ID=$(aws ec2 create-vpc --cidr-block $CIDR_BLOCK --region $REGION --query 'Vpc.VpcId' --output text)
echo "Created VPC: $VPC_ID"

# Tag VPC
# Tags help identify and organize resources. Here, we name the VPC.
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $REGION

# Create Internet Gateway
# An Internet Gateway (IGW) allows communication between the VPC and the internet.
IGW_ID=$(aws ec2 create-internet-gateway --region $REGION --query 'InternetGateway.InternetGatewayId' --output text)
echo "Created Internet Gateway: $IGW_ID"

# Attach Internet Gateway to VPC
# Attaching the IGW to the VPC enables internet access for resources in the VPC.
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION

# Create Public Subnet
# A subnet is a range of IP addresses in the VPC. Public subnets allow resources to communicate with the internet.
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUBLIC_SUBNET_CIDR --region $REGION --query 'Subnet.SubnetId' --output text)
echo "Created Public Subnet: $PUBLIC_SUBNET_ID"

# Create Private Subnet
# Private subnets are used for resources that should not be directly accessible from the internet.
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PRIVATE_SUBNET_CIDR --region $REGION --query 'Subnet.SubnetId' --output text)
echo "Created Private Subnet: $PRIVATE_SUBNET_ID"

# Create Public Route Table
# A route table contains rules that determine how traffic is directed within the VPC.
PUBLIC_RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION --query 'RouteTable.RouteTableId' --output text)
echo "Created Public Route Table: $PUBLIC_RT_ID"

# Create Route to Internet Gateway in Public Route Table
# This route allows traffic from the public subnet to reach the internet via the IGW.
aws ec2 create-route --route-table-id $PUBLIC_RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $REGION

# Associate Public Route Table with Public Subnet
# Associating the route table with the public subnet enables internet access for resources in the subnet.
aws ec2 associate-route-table --route-table-id $PUBLIC_RT_ID --subnet-id $PUBLIC_SUBNET_ID --region $REGION

# Enable Auto-assign Public IP on Public Subnet
# This ensures that instances launched in the public subnet automatically receive a public IP address.
aws ec2 modify-subnet-attribute --subnet-id $PUBLIC_SUBNET_ID --map-public-ip-on-launch --region $REGION

# Create NAT Gateway in Public Subnet
# A NAT Gateway allows instances in the private subnet to access the internet without exposing them to incoming traffic.
EIP_ALLOC_ID=$(aws ec2 allocate-address --domain vpc --region $REGION --query 'AllocationId' --output text)
NAT_GW_ID=$(aws ec2 create-nat-gateway --subnet-id $PUBLIC_SUBNET_ID --allocation-id $EIP_ALLOC_ID --region $REGION --query 'NatGateway.NatGatewayId' --output text)
echo "Created NAT Gateway: $NAT_GW_ID"

# Wait for NAT Gateway to become available
# NAT Gateway must be in an available state before it can be used.
echo "Waiting for NAT Gateway to become available..."
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_ID --region $REGION

# Create Private Route Table
# A separate route table for the private subnet ensures traffic is routed through the NAT Gateway.
PRIVATE_RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --region $REGION --query 'RouteTable.RouteTableId' --output text)
echo "Created Private Route Table: $PRIVATE_RT_ID"

# Create Route to NAT Gateway in Private Route Table
# This route allows traffic from the private subnet to reach the internet via the NAT Gateway.
aws ec2 create-route --route-table-id $PRIVATE_RT_ID --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NAT_GW_ID --region $REGION

# Associate Private Route Table with Private Subnet
# Associating the route table with the private subnet ensures proper routing for private resources.
aws ec2 associate-route-table --route-table-id $PRIVATE_RT_ID --subnet-id $PRIVATE_SUBNET_ID --region $REGION

echo "VPC setup complete. VPC ID: $VPC_ID"

#export resource IDs for cleanup 
export VPC_ID=$VPC_ID
export IGW_ID=$IGW_ID
export PUBLIC_SUBNET_ID=$PUBLIC_SUBNET_ID
export PRIVATE_SUBNET_ID=$PRIVATE_SUBNET_ID
export PUBLIC_RT_ID=$PUBLIC_RT_ID
export PRIVATE_RT_ID=$PRIVATE_RT_ID
export NAT_GW_ID=$NAT_GW_ID
export EIP_ALLOC_ID=$EIP_ALLOC_ID
