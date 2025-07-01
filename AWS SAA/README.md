# AWS Solutions Architect Associate Hands-On Lab

This folder contains hands-on training materials and labs for the AWS Solutions Architect Associate (SAA) exam, with a focus on practical, real-world skills for interacting with AWS services and managing infrastructure as code.

## Lab Approach
- **Multi-Tool Exposure:**
  - Demonstrates various ways to interact with AWS: AWS CLI, Python SDK (boto3), and shell scripts.
  - Emphasizes Terraform as the primary tool for infrastructure automation and management.
- **Progressive Learning:**
  - Start with basics (manual/CLI), then move to automation (scripts), and finally to full IaC (Terraform).
- **Best Practices:**
  - Showcases modular, parameterized, and reusable Terraform code.
  - Encourages version control, repeatability, and automation.

## What You'll Learn
- How to set up and configure AWS CLI and Terraform
- How to use the AWS CLI and Python SDK for basic resource management
- How to write, plan, apply, and destroy infrastructure using Terraform
- How to structure Terraform code for real-world projects
- How to use modules, variables, outputs, and state
- How to manage infrastructure lifecycle and automate deployments

## Folder Structure
- `AWSCLIsetup.txt` — AWS CLI installation and setup
- `python-sdk-setup/` — Python SDK (boto3) setup and usage examples
- `tfsetup.txt` — Terraform installation, setup, and usage basics
- `Basics/` — Common AWS CLI commands for Mac and Windows
- `AWS CLI Examples/` — Shell scripts for common AWS tasks (EC2, IAM, VPC)
- `PythonSDKExamples/` — Python scripts for AWS resource management
- `TerraformExamples/` — Real-world Terraform code for EC2, VPC, S3, IAM, RDS, etc.

## Why Terraform?
- **Declarative:** Define what you want, not how to do it
- **Idempotent:** Safe to run multiple times
- **Modular:** Reuse code with modules
- **Stateful:** Tracks infrastructure for drift detection and updates
- **Provider Ecosystem:** Supports AWS and many other clouds/services

## Example: Launching an EC2 Instance with Terraform
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  tags = {
    Name = "ExampleInstance"
  }
}
```

## Getting Started
1. Install AWS CLI and Terraform (see `AWSCLIsetup.txt` and `tfsetup.txt`)
2. Configure your AWS credentials
3. Use the provided scripts and Terraform examples to practice
4. Experiment, break things, and learn by doing!

## Additional Resources
- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS CLI Docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
- [AWS Python SDK (boto3)](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
