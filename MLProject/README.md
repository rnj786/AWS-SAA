# MLExample: Meal Recommendation

This project builds a Machine Learning application on AWS to recommend meals for individuals and families. It includes:
- Terraform infrastructure for S3, SageMaker (training + serverless endpoint), and API Gateway
- Python scripts for data generation, model training, and inference
- Serverless API for meal recommendations

## Project Structure
- `infra/terraform/` - Terraform code for AWS resources
- `data/` - Scripts and sample data for meal records
- `src/` - ML training and inference code
- `api/` - API Gateway integration scripts
- `.github/copilot-instructions.md` - Copilot customization

## Quick Start
1. Generate meal data and upload to S3
2. Deploy infrastructure with Terraform
3. Train and deploy the model on SageMaker
4. Use the API Gateway endpoint for recommendations

See detailed instructions in each folder.
