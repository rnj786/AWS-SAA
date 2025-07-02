import boto3
import os

def upload_to_s3(file_path, bucket, key):
    s3 = boto3.client('s3')
    s3.upload_file(file_path, bucket, key)
    print(f"Uploaded {file_path} to s3://{bucket}/{key}")

if __name__ == "__main__":
    bucket = os.environ.get("MEAL_DATA_BUCKET")
    file_path = "data/meal_data.csv"
    key = "meal_data.csv"
    if not bucket:
        print("Set the MEAL_DATA_BUCKET environment variable.")
    else:
        upload_to_s3(file_path, bucket, key)
