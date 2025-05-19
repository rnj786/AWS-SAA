# Terraform EC2 Example

This guide provides step-by-step instructions to deploy an EC2 instance with all dependencies using Terraform.

## Prerequisites
1. **Terraform Installed**: Ensure Terraform is installed on your system. Follow the [Terraform Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2. **AWS CLI Configured**: Ensure AWS CLI is installed and configured with appropriate credentials.
3. **AWS Permissions**: Ensure your AWS credentials have permissions to create EC2 instances, security groups, and key pairs.

## Steps to Deploy the Terraform Code

### 1. Clone the Repository
Navigate to the directory where you want to clone the repository and run:
```bash
git clone <repository-url>
```

### 2. Navigate to the Terraform Directory
Change to the directory containing the Terraform code:
```bash
cd TerraformExamples/EC2
```

### 3. Initialize Terraform
Run the following command to initialize Terraform and download the required providers:
```bash
terraform init
```

### 4. Review the Variables
Open the `variables.tf` file and review the default values for the variables. Update them if needed:
- `region`: AWS region to deploy resources.
- `key_name`: Name of the key pair.
- `public_key_path`: Path to your public key file.
- `ami_id`: AMI ID for the EC2 instance.
- `subnet_id`: Subnet ID for the EC2 instance.
- `kms_key_id`: KMS Key ID for EBS volume encryption.

### 5. Validate the Configuration
Run the following command to validate the Terraform configuration:
```bash
terraform validate
```

### 6. Preview the Changes
Run the following command to preview the changes Terraform will make:
```bash
terraform plan
```

### 7. Apply the Changes
Run the following command to create the resources:
```bash
terraform apply
```
Confirm the prompt to proceed.

### 8. Verify the Resources
After the apply command completes, verify the resources in the AWS Management Console:
- EC2 Instance: Check the instance details, including the public IP address.
- Security Group: Verify the inbound and outbound rules.

## Steps to Destroy the Resources

### 1. Destroy the Resources
Run the following command to destroy the resources created by Terraform:
```bash
terraform destroy
```
Confirm the prompt to proceed.

### 2. Verify Deletion
After the destroy command completes, verify that the resources have been removed in the AWS Management Console.

## Additional Notes
- Always review the `terraform plan` output before applying changes.
- Use a dedicated AWS account or environment for testing to avoid impacting production resources.