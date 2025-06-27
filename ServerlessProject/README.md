# Serverless File Manager on AWS

This project is a full-stack serverless application for managing files in S3 using a React frontend, a Python Lambda backend, and AWS API Gateway. Infrastructure is managed with Terraform.

---

## Prerequisites
- AWS account with sufficient permissions (S3, Lambda, API Gateway, IAM)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured (`aws configure`)
- [Terraform](https://www.terraform.io/downloads.html) v1.0+
- [Node.js](https://nodejs.org/) (v16+ recommended)
- [npm](https://www.npmjs.com/)
- Python 3.8+

---

## 1. Clone the Repository
```bash
git clone <your-repo-url>
cd ServerlessProject
```

---

## 2. Infrastructure Setup with Terraform

### a. Configure Variables
Edit `terraform/terraform.tfvars` or use environment variables to set:
- S3 bucket names
- Lambda function settings
- API Gateway domain (optional)

### b. Build and Upload Lambda Package
```bash
cd pythonLambda
./build_and_upload_python_lambda.sh
cd ../terraform
```
This script will package the Lambda code and upload it to the deployment S3 bucket.

### c. Initialize and Apply Terraform
```bash
terraform init
terraform apply
```
- Review the plan and type `yes` to deploy.
- Outputs will include the API Gateway endpoint and S3 website URL.

---

## 3. Frontend Setup

### a. Configure API Endpoint
Edit `frontend/.env`:
```
REACT_APP_API_URL=<API Gateway Invoke URL>
```

### b. Build and Deploy the React App
Use the provided script to build and deploy the frontend in one step:
```bash
cd ../frontend
../deploy_react_to_s3.sh
```
This script will build the React app and upload the build output to your S3 website bucket (as configured in Terraform outputs).

- Make sure S3 static website hosting is enabled and CORS is configured (handled by Terraform).

---

## 4. Using the App
- Open the S3 website URL in your browser.
- Upload, list, and delete files using the React UI.
- All file operations are routed through API Gateway and Lambda for security.

---

## 5. Cleanup
To remove all resources:
```bash
cd ../terraform
terraform destroy
```

---

## Troubleshooting
- Ensure your AWS credentials are set and have the required permissions.
- If Lambda upload fails, check the CloudWatch logs for errors.
- For CORS issues, verify API Gateway and S3 CORS settings.

---

## Project Structure
- `terraform/` — Infrastructure as code (modules for S3, Lambda, API Gateway)
- `pythonLambda/` — Python Lambda function and build scripts
- `frontend/` — React app for file management

---

## License
MIT
