#!/bin/bash
set -e

# Setup AWS resources required for Terraform
# Usage: ./scripts/setup-aws.sh

echo "Gadgetcloud.io - AWS Setup Script"
echo "=================================="
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed"
    echo "Install it from: https://aws.amazon.com/cli/"
    exit 1
fi

# Check AWS credentials
echo "Checking AWS credentials..."
if ! aws sts get-caller-identity &> /dev/null; then
    echo "Error: AWS credentials not configured"
    echo ""
    echo "Please configure AWS credentials:"
    echo "  aws configure"
    echo ""
    echo "Or set environment variables:"
    echo "  export AWS_ACCESS_KEY_ID=your-key"
    echo "  export AWS_SECRET_ACCESS_KEY=your-secret"
    echo "  export AWS_DEFAULT_REGION=ap-south-1"
    exit 1
fi

# Display current AWS identity
echo "AWS Identity:"
aws sts get-caller-identity
echo ""

# Configuration
BUCKET_NAME="tf-state.gadgetcloud.io"
REGION="ap-south-1"

# Check if bucket already exists
echo "Checking if S3 bucket exists..."
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "✓ S3 bucket '$BUCKET_NAME' already exists"
else
    echo "Creating S3 bucket '$BUCKET_NAME'..."

    # Create bucket
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$REGION" \
        --create-bucket-configuration LocationConstraint="$REGION"

    echo "✓ S3 bucket created"
fi

# Enable versioning
echo "Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled
echo "✓ Versioning enabled"

# Enable encryption
echo "Enabling encryption on S3 bucket..."
aws s3api put-bucket-encryption \
    --bucket "$BUCKET_NAME" \
    --server-side-encryption-configuration '{
        "Rules": [{
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            },
            "BucketKeyEnabled": true
        }]
    }'
echo "✓ Encryption enabled"

# Block public access
echo "Blocking public access to S3 bucket..."
aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration \
        BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
echo "✓ Public access blocked"

echo ""
echo "=================================="
echo "AWS Setup Complete!"
echo "=================================="
echo ""
echo "S3 Bucket: $BUCKET_NAME"
echo "Region: $REGION"
echo ""
echo "Next steps:"
echo "1. Update parameter values:"
echo "   vim configs/dev/parameters.tfvars"
echo ""
echo "2. Validate configuration:"
echo "   python3 scripts/validate-config.py configs/dev/parameters.tfvars"
echo ""
echo "3. Deploy to dev:"
echo "   ./scripts/deploy.sh dev"
echo ""
