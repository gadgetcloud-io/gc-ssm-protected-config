# AWS Setup Guide

This guide explains how to set up AWS credentials and required resources for deploying the SSM configuration.

## Prerequisites

1. AWS Account with administrator access (or appropriate IAM permissions)
2. AWS CLI installed and configured
3. Terraform >= 1.0 installed

## Step 1: Configure AWS Credentials

### Option A: AWS CLI Configuration (Recommended)

```bash
# Configure AWS CLI with your credentials
aws configure

# You'll be prompted for:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region: ap-south-1
# - Default output format: json
```

### Option B: Environment Variables

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="ap-south-1"
```

### Option C: AWS Profile

```bash
# Configure a named profile
aws configure --profile gadgetcloud

# Use the profile
export AWS_PROFILE=gadgetcloud
```

## Step 2: Verify AWS Access

```bash
# Test AWS credentials
aws sts get-caller-identity

# Expected output:
# {
#     "UserId": "AIDAXXXXXXXXXXXXXXXXX",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/yourname"
# }
```

## Step 3: Create S3 Bucket for Terraform State

The S3 bucket stores Terraform state files. Create it before deploying:

```bash
# Create the S3 bucket
aws s3api create-bucket \
    --bucket tf-state.gadgetcloud.io \
    --region ap-south-1 \
    --create-bucket-configuration LocationConstraint=ap-south-1

# Enable versioning (recommended for state files)
aws s3api put-bucket-versioning \
    --bucket tf-state.gadgetcloud.io \
    --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
    --bucket tf-state.gadgetcloud.io \
    --server-side-encryption-configuration '{
        "Rules": [{
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }]
    }'

# Block public access
aws s3api put-public-access-block \
    --bucket tf-state.gadgetcloud.io \
    --public-access-block-configuration \
        BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

## Step 4: Required IAM Permissions

Your AWS user/role needs these permissions:

### For Terraform State (S3)
- `s3:GetObject`
- `s3:PutObject`
- `s3:DeleteObject`
- `s3:ListBucket`

### For SSM Parameters
- `ssm:PutParameter`
- `ssm:GetParameter`
- `ssm:DeleteParameter`
- `ssm:DescribeParameters`
- `ssm:AddTagsToResource`

### For KMS (encryption)
- `kms:CreateKey`
- `kms:CreateAlias`
- `kms:DescribeKey`
- `kms:EnableKeyRotation`
- `kms:TagResource`

### For IAM (creating Lambda policies)
- `iam:CreatePolicy`
- `iam:GetPolicy`
- `iam:DeletePolicy`
- `iam:TagPolicy`

## Step 5: Update Configuration Files

Before deploying, update the parameter values:

```bash
# Edit dev parameters
vim configs/dev/parameters.tfvars

# Replace all CHANGE_ME values with actual secrets
# - database/password
# - external/payment_api_key
```

## Step 6: Deploy

Once AWS is configured:

```bash
# Validate configuration
python3 scripts/validate-config.py configs/dev/parameters.tfvars

# Deploy to dev
./scripts/deploy.sh dev
```

## Troubleshooting

### Error: "no valid credential sources"
- Run `aws configure` to set up credentials
- Or set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables

### Error: "The specified bucket does not exist"
- Create the S3 bucket using the command in Step 3
- Or update `configs/dev/backend.tfvars` with an existing bucket name

### Error: "Access Denied"
- Verify your IAM user/role has the required permissions
- Check `aws sts get-caller-identity` to confirm credentials are working

### Error: "CHANGE_ME placeholder values"
- Run validation: `python3 scripts/validate-config.py configs/dev/parameters.tfvars`
- Update all CHANGE_ME values in the parameters file

## Security Best Practices

1. **Never commit credentials** to git
2. **Use IAM roles** instead of access keys when possible (e.g., EC2, Lambda)
3. **Enable MFA** for your AWS account
4. **Rotate credentials** regularly
5. **Use least privilege** - grant only necessary permissions
6. **Enable CloudTrail** to audit all API calls
7. **Use SecureString** type for all sensitive SSM parameters

## Next Steps

After successful deployment:
1. Verify parameters: `./scripts/list-parameters.sh dev`
2. Test parameter retrieval: `./scripts/get-parameter.sh dev database/host`
3. Attach the Lambda IAM policy to your Lambda execution roles
4. Deploy to staging and production environments
