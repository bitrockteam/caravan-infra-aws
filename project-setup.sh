#!/usr/bin/env bash

NAME=$1
REGION=$2
PROFILE=$3

BUCKET_NAME=$NAME-terraform-state
TABLE_NAME=$NAME-terraform-state-lock

echo -e "\033[32mCreating S3 Bucket $BUCKET_NAME\033[0m"
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --create-bucket-configuration "LocationConstraint=$REGION" \
  --profile "$PROFILE"
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --versioning-configuration Status=Enabled \
  --profile "$PROFILE"

echo -e "\033[32mCreating DynamoDB Table $TABLE_NAME\033[0m"
aws dynamodb create-table \
  --region "$REGION" \
  --table-name "$TABLE_NAME" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema KeyType=HASH,AttributeName=LockID \
  --billing-mode PAY_PER_REQUEST \
  --profile "$PROFILE"

echo -e "\033[32mDone!\033[0m"
