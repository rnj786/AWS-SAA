#!/bin/bash
# Deploy EKS cluster, VPC, Karpenter, and ALB controller using Terraform and Helm
set -e
cd $(dirname $0)/../terraform

echo "Initializing and applying Terraform for VPC, EKS, IAM, Karpenter, and ALB..."
terraform init
terraform apply -auto-approve

# Get kubeconfig for EKS
aws eks update-kubeconfig --region $(terraform output -raw region) --name $(terraform output -raw cluster_name)

# Install Karpenter CRDs and controller (if not done by Terraform)
# helm repo add karpenter https://charts.karpenter.sh
# helm upgrade --install karpenter karpenter/karpenter -n karpenter --create-namespace \
#   --set controller.clusterName=$(terraform output -raw cluster_name) \
#   --set controller.clusterEndpoint=$(terraform output -raw cluster_endpoint) \
#   --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=$(terraform output -raw karpenter_role_arn)

# Install AWS Load Balancer Controller (if not done by Terraform)
# helm repo add eks https://aws.github.io/eks-charts
# helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
#   --set clusterName=$(terraform output -raw cluster_name) \
#   --set serviceAccount.create=false \
#   --set serviceAccount.name=aws-load-balancer-controller \
#   --set region=$(terraform output -raw region) \
#   --set vpcId=$(terraform output -raw vpc_id)

echo "EKS infrastructure deployed."
