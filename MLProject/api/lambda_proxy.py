# API Gateway integration Lambda (optional, for proxying to SageMaker endpoint)
import boto3
import os
import json

def lambda_handler(event, context):
    sagemaker = boto3.client('sagemaker-runtime')
    endpoint_name = os.environ['SAGEMAKER_ENDPOINT']
    body = event.get('body', '{}')
    response = sagemaker.invoke_endpoint(
        EndpointName=endpoint_name,
        ContentType='application/json',
        Body=body
    )
    result = response['Body'].read().decode()
    return {
        'statusCode': 200,
        'body': result
    }
