#!/bin/bash
# build_and_upload_python_lambda.sh
# Usage: ./build_and_upload_python_lambda.sh <bucket> <key>
set -e

LAMBDA_DIR="$(dirname "$0")"
ZIP_FILE="lambda_function.zip"

cd "$LAMBDA_DIR"
pip install --target ./package boto3
cp lambda_function.py package/
cd package
zip -r9 ../$ZIP_FILE .
cd ..

if [ $# -eq 2 ]; then
  aws s3 cp $ZIP_FILE s3://$1/$2
  echo "Uploaded $ZIP_FILE to s3://$1/$2"
else
  echo "Build complete. To upload, run: aws s3 cp $ZIP_FILE s3://<bucket>/<key>"
fi
