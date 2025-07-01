# EventsRSVP Microservice on AWS (ECS + API Gateway + DynamoDB)

This project provides a scalable Java Spring Boot microservice for managing event RSVPs, with a REST API, AWS ECS deployment, API Gateway, and DynamoDB integration. It also includes a Google Forms integration for automated RSVP submissions.

---

## Prerequisites
- AWS account with permissions for ECS, ECR, API Gateway, DynamoDB, IAM, VPC, and CloudWatch
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured
- [Terraform](https://www.terraform.io/downloads.html)
- [Docker](https://www.docker.com/)
- [Maven](https://maven.apache.org/)
- Java 17+

---

## 1. Clone the Repository
```bash
git clone <your-repo-url>
cd ECSProject
```

---

## 2. Build and Push Docker Image to ECR

1. **Build the JAR:**
   ```bash
   cd eventsrsvp-service
   mvn clean package
   ```
2. **Build Docker Image:**
   ```bash
   docker build -t <your-ecr-repo>:<tag> .
   ```
3. **Authenticate Docker to ECR:**
   ```bash
   aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
   ```
4. **Push Image to ECR:**
   ```bash
   docker push <your-ecr-repo>:<tag>
   ```

---

## 3. Deploy Infrastructure with Terraform

1. **Configure Variables:**
   - Edit `Terraform/variables.tf` and `Terraform/terraform.tfvars` as needed (ECR image URI, VPC, etc).
2. **Deploy:**
   ```bash
   cd ../Terraform
   terraform init
   terraform apply
   ```
   - Confirm the plan and type `yes` to deploy.
   - Outputs will include the ALB DNS name and other endpoints.

---

## 4. Test the API

1. **Run the Test Script:**
   ```bash
   cd ../test
   ./test_eventsrsvp_api.sh http://<alb-dns-name>
   ```
2. **Check CloudWatch Logs:**
   - View logs for ECS tasks and troubleshoot as needed.

---

## 5. Google Forms Integration (Optional)

See `google-forms-integration/README.md` for step-by-step instructions to capture RSVPs from Google Forms and submit to your API.

---

## 6. Cleanup
To remove all resources:
```bash
cd ../Terraform
terraform destroy
```

---

## Project Structure
- `eventsrsvp-service/` — Spring Boot microservice
- `Terraform/` — Infrastructure as code (ECS, ALB, API Gateway, DynamoDB)
- `test/` — API test scripts
- `google-forms-integration/` — Google Forms Apps Script integration

---

## License
MIT
