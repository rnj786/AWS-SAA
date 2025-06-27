#!/bin/bash
set -e

# --- Config ---
FRONTEND_DIR="./frontend"
S3_BUCKET="$1"

if [ -z "$S3_BUCKET" ]; then
  echo "Usage: $0 <s3-bucket-name>"
  exit 1
fi

# Step 1: Build React app
cd "$FRONTEND_DIR"
npm install
npm run build

# Step 2: Sync build folder to S3
aws s3 sync build/ "s3://$S3_BUCKET/" --delete

echo "React app deployed to S3 bucket: $S3_BUCKET"
