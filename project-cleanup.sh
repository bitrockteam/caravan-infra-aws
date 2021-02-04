#!/usr/bin/env bash

NAME=$1
REGION=$2
PROFILE=$3

BUCKET_NAME=$NAME-terraform-state
TABLE_NAME=$NAME-terraform-state-lock

echo "Deleting S3 Bucket $BUCKET_NAME"
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --versioning-configuration Status=Suspended \
  --profile "$PROFILE"
aws s3api delete-objects \
      --bucket "$BUCKET_NAME" \
      --delete "$(aws s3api list-object-versions \
      --bucket "$BUCKET_NAME" | \
      jq '{Objects: [.Versions[] | {Key:.Key, VersionId : .VersionId}], Quiet: false}')"
aws s3api delete-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$REGION" \
  --profile "$PROFILE"

echo "Deleting DynamoDB Table $TABLE_NAME"
aws dynamodb delete-table \
  --region "$REGION" \
  --table-name "$TABLE_NAME" \
  --profile "$PROFILE"

