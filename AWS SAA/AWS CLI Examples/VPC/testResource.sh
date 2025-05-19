VPC_ID="vpc-00fb5a701b57eb48c"
IGW_ID="igw-068c1e7b38b3f81bc"
PUBLIC_SUBNET_ID="subnet-0fb8ba7ae9ce45f78"
PRIVATE_SUBNET_ID="subnet-07487a98395d1222a"
PUBLIC_RT_ID="rtb-0c26f47e14b6692a6"
PRIVATE_RT_ID="rtb-07a032fd11947bb6a"
NAT_GW_ID="nat-04ff05f5e79ce8d71"
EIP_ALLOC_ID="eipalloc-0e6393c99def3913b"

CSV_FILE="VPCResources.csv"
echo "ResourceType,ResourceID" > $CSV_FILE
echo "VPC,$VPC_ID" >> $CSV_FILE
echo "InternetGateway,$IGW_ID" >> $CSV_FILE
echo "PublicSubnet,$PUBLIC_SUBNET_ID" >> $CSV_FILE
echo "PrivateSubnet,$PRIVATE_SUBNET_ID" >> $CSV_FILE
echo "PublicRouteTable,$PUBLIC_RT_ID" >> $CSV_FILE
echo "PrivateRouteTable,$PRIVATE_RT_ID" >> $CSV_FILE
echo "NATGateway,$NAT_GW_ID" >> $CSV_FILE
echo "ElasticIP,$EIP_ALLOC_ID" >> $CSV_FILE