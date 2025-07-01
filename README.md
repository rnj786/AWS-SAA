# AWS Solutions Architect Hands-On Labs: Multi-Project Summary

This repository contains a comprehensive set of hands-on labs and real-world projects for AWS Solutions Architect training. It demonstrates multiple ways to interact with AWS services, with a strong focus on Infrastructure as Code (IaC) using Terraform, and includes end-to-end examples for modern cloud-native architectures.

---

## Contents & Structure

- **AWS SAA/**: Core hands-on labs for the AWS Solutions Architect Associate exam, including AWS CLI, Python SDK (boto3), and Terraform examples for EC2, S3, IAM, VPC, and more.
- **ECSProject/**: Java Spring Boot microservice for EventsRSVP, deployed on AWS ECS with API Gateway and DynamoDB, plus Google Forms integration and API test scripts.
- **EKSProject/**: Kubernetes (EKS) project examples and integrations.
- **ServerlessProject/**: Full-stack serverless app with React frontend, Python Lambda backend, API Gateway, and S3, all managed with Terraform.

---

## Approach
- **Multi-Tool Learning:**
  - Start with AWS CLI and Python SDK for direct resource management.
  - Progress to automation and best practices with Terraform as the primary IaC tool.
- **Real-World Scenarios:**
  - Each project is structured to reflect real cloud architectures, including modular Terraform, CI/CD, and integration with AWS managed services.
- **End-to-End Examples:**
  - From basic resource creation to advanced automation, API integrations, and frontend/backend deployments.

---

## Key Projects

### AWS SAA
- Step-by-step labs for AWS CLI, Python SDK, and Terraform.
- Modular, reusable Terraform code for common AWS resources.
- Focus on best practices and exam-relevant scenarios.

### ECSProject
- Spring Boot REST API for EventsRSVP, containerized and deployed to ECS Fargate.
- API Gateway and DynamoDB integration.
- Automated build, push, and deploy scripts.
- Google Forms integration for automated RSVP submissions.
- API test scripts for validation.

### ServerlessProject
- React SPA frontend, Python Lambda backend, API Gateway, and S3 static hosting.
- All infrastructure managed with Terraform modules.
- End-to-end deployment and CI/CD ready.

### EKSProject
- Kubernetes (EKS) cluster setup and integration examples.

---

## Getting Started
1. See each project folder for detailed setup and deployment instructions.
2. Start with AWS SAA for foundational skills, then explore ECSProject and ServerlessProject for advanced, real-world architectures.
3. Use the provided scripts and Terraform modules to practice, experiment, and learn by doing.

---

## Why Terraform?
- Declarative, idempotent, modular, and stateful IaC for AWS and beyond.
- Enables repeatable, version-controlled, and automated cloud deployments.

---

## Additional Resources
- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [AWS CLI Docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
- [AWS Python SDK (boto3)](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

---

## License
MIT
