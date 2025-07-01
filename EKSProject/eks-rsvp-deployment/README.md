# Deploying EventsRSVP Microservice on Amazon EKS with Karpenter, Spot Scaling, and API Gateway

This guide walks you through deploying the Java Spring Boot EventsRSVP microservice (previously containerized and published to ECR) on Amazon EKS. The deployment includes:
- Secure, non-overlapping VPC with public/private subnets
- EKS cluster with IAM roles and policies
- Karpenter for dynamic, spot-based node scaling (min 0/1, max 3)
- CloudWatch logging for all components
- Automated deployment scripts for the RSVP microservice
- ALB ingress and API Gateway proxy for public API access

---

## Prerequisites
- AWS CLI and `kubectl` installed and configured
- [eksctl](https://eksctl.io/) and [helm](https://helm.sh/) installed
- [Terraform](https://www.terraform.io/downloads.html)
- Docker and ECR image for RSVP microservice (from ECS example)
- Sufficient AWS permissions (EKS, VPC, IAM, EC2, ALB, API Gateway, CloudWatch)

---

## 1. Infrastructure Setup with Terraform

### a. VPC and Networking
- Create a non-overlapping VPC with public and private subnets across at least 2 AZs.
- Enable VPC endpoints for ECR, S3, and CloudWatch.

### b. EKS Cluster and IAM
- Use Terraform to provision the EKS cluster, node IAM roles, and OIDC provider.
- Enable cluster logging to CloudWatch.

### c. Karpenter Setup
- Deploy Karpenter via Helm with a provisioner for spot instances (fallback to on-demand if needed).
- Configure scaling: min 0/1 nodes, max 3 nodes.
- Use node selectors and taints to prefer spot capacity.

---

## 2. RSVP Microservice Deployment

### a. Namespace and RBAC
- Create a dedicated namespace (e.g., `rsvp`).
- Apply RBAC for service account and logging.

### b. Deploy RSVP Microservice
- Use a Kubernetes Deployment manifest referencing the ECR image.
- Set resource requests/limits for efficient scaling.
- Enable CloudWatch logging via sidecar or Fluent Bit DaemonSet.

### c. Expose via ALB Ingress
- Deploy AWS Load Balancer Controller (via Helm).
- Annotate the RSVP service for ALB ingress.
- Ensure the ALB is internet-facing and logs to CloudWatch.

---

## 3. API Gateway Proxy
- Create an API Gateway (HTTP or REST) to proxy requests to the ALB endpoint.
- Enable CORS and logging.
- Secure the endpoint as needed (API key, IAM, etc).

---

## 4. Scripts and Automation
- `deploy_eks_infra.sh`: Provisions VPC, EKS, Karpenter, and ALB controller.
- `deploy_rsvp_microservice.sh`: Deploys the RSVP app, service, and ingress.
- `deploy_api_gateway.sh`: Creates API Gateway and sets up proxy integration.

---

## 5. Cleanup
- `destroy_eks_infra.sh`: Tears down all EKS and networking resources.
- Remove API Gateway and ECR images as needed.

---

## 6. Monitoring and Logging
- All EKS, Karpenter, and RSVP app logs are sent to CloudWatch.
- ALB and API Gateway access logs are enabled.

---

## Example Directory Structure
```
eks-rsvp-deployment/
  ├── README.md
  ├── terraform/           # VPC, EKS, IAM, Karpenter, ALB, API Gateway
  ├── manifests/           # Kubernetes YAMLs for RSVP app, service, ingress
  ├── scripts/             # Shell scripts for automation
```

---

## References
- [Karpenter Docs](https://karpenter.sh/docs/)
- [AWS EKS Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-eks)
- [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)
- [API Gateway HTTP Proxy](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-http.html)
