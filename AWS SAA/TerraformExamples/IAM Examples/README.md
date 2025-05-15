# Terraform IAM Examples

This guide provides step-by-step instructions to run the Terraform code to create IAM resources (role, group, and user) and how to destroy them.

## Prerequisites
1. **Terraform Installed**: Ensure Terraform is installed on your system. If not, follow the [Terraform Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2. **AWS CLI Configured**: Ensure AWS CLI is installed and configured with appropriate credentials.
3. **AWS Permissions**: Ensure your AWS credentials have permissions to create IAM roles, groups, and users.

## Steps to Run the Terraform Code

### 1. Clone the Repository
Navigate to the directory where you want to clone the repository and run:
```bash
git clone <repository-url>
```

### 2. Navigate to the Terraform Directory
Change to the directory containing the Terraform code:
```bash
cd TerraformExamples/IAM Examples
```

### 3. Initialize Terraform
Run the following command to initialize Terraform and download the required providers:
```bash
terraform init
```

### 4. Review the Variables
Open the `variables.tf` file and review the default values for the variables. Update them if needed:
- `region`: AWS region to deploy resources.
- `role_name`: Name of the IAM role.
- `group_name`: Name of the IAM group.
- `user_name`: Name of the IAM user.

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
- IAM Role: `TFRole` (or the name you specified in `role_name`)
- IAM Group: `EC2TFModerator` (or the name you specified in `group_name`)
- IAM User: `TFUser` (or the name you specified in `user_name`)

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
- Ensure you have the necessary permissions to create and destroy IAM resources.
- Use a dedicated AWS account or environment for testing to avoid impacting production resources.
