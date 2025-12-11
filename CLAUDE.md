# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Deployment Status

**All environments are deployed and operational!**

- **AWS Profile**: `gc`
- **AWS Account**: 860154085634
- **Region**: ap-south-1 (Mumbai)
- **S3 Backend**: tf-state.gadgetcloud.io
- **Deployed**: dev (6 params), stg (6 params), prd (6 params)

## Project Overview

This repository manages centralized configuration for **Gadgetcloud.io** (Your Gadgets, Your Cloud) using AWS Systems Manager (SSM) Parameter Store. Configuration parameters are consumed by Lambda microservices across multiple environments (dev, stg, prd).

## Key Architecture

### Parameter Storage Pattern

All SSM parameters follow this hierarchical structure:
```
/gadgetcloud/{environment}/{category}/{parameter-name}
```

This naming convention enables:
- Environment isolation (dev/stg/prd never share parameters)
- Category-based bulk retrieval using `GetParametersByPath`
- Consistent Lambda IAM policies across microservices

### Security Model

- **KMS Encryption**: Each environment has its own KMS key for SecureString parameters
- **IAM Policy**: Terraform creates a reusable policy (`lambda_ssm_read_policy_arn`) that grants read access to all parameters in an environment
- **Least Privilege**: Lambda functions should only be granted access to their environment's parameters

### Terraform State Management

- Uses S3 backend for storing Terraform state (configured per environment)
- Backend config files (`configs/{env}/backend.tfvars`) configured with AWS profile `gc`
- Each environment maintains separate state to prevent cross-environment interference
- State locking is handled by S3's native versioning and consistency model
- All backend configs use profile `gc` for authentication

## Development Commands

### Deploy Configuration to an Environment

```bash
# Deploy to dev (most common)
./scripts/deploy.sh dev

# Deploy to stg
./scripts/deploy.sh stg

# Deploy to prd (requires confirmation)
./scripts/deploy.sh prd
```

**Important**: Configuration files already exist for all environments. Update `configs/{env}/parameters.tfvars` to replace `CHANGE_ME` placeholder values with actual secrets before deploying.

### Validate Configuration Before Deployment

```bash
python3 scripts/validate-config.py configs/dev/parameters.tfvars
```

This checks for:
- `CHANGE_ME` placeholders that weren't replaced
- Sensitive-looking parameters (password, key, token, secret) not using `SecureString` type

### Query Parameters from AWS

```bash
# List all parameters in an environment
./scripts/list-parameters.sh dev

# Get a single parameter value
./scripts/get-parameter.sh dev database/host

# Get and decrypt a SecureString parameter
./scripts/get-parameter.sh prd database/password --decrypt
```

### Direct Terraform Operations

```bash
cd terraform

# Initialize (with backend)
terraform init -backend-config=../configs/dev/backend.tfvars -reconfigure

# Plan changes for specific environment
terraform plan -var-file=../configs/dev/parameters.tfvars

# Apply changes
terraform apply -var-file=../configs/dev/parameters.tfvars

# View outputs (KMS key ARN, policy ARN, etc.)
terraform output

# Import existing parameter
terraform import 'aws_ssm_parameter.config["database/host"]' /gadgetcloud/dev/database/host
```

## Code Architecture

### Terraform Structure

- **main.tf**: Provider config and S3 backend declaration
- **variables.tf**: Input variables including the `parameters` map
- **ssm.tf**: Core resources - SSM parameters, KMS key, and Lambda IAM policy
- **outputs.tf**: Exports parameter ARNs and policy ARN for Lambda integration

### Configuration Files (`configs/{env}/`)

The `parameters` variable in `.tfvars` files uses this structure:

```hcl
parameters = {
  "category/parameter-name" = {
    value       = "actual-value"
    type        = "String|SecureString|StringList"
    description = "Human-readable description"
    tier        = "Standard"  # Optional: "Advanced" for >4KB values
  }
}
```

This map is iterated in `ssm.tf` using `for_each` to create all parameters.

### Lambda Integration Helpers

**Python** (`examples/lambda/config_loader.py`):
- `ConfigLoader` class with caching via `@lru_cache`
- Methods: `get_parameter()`, `get_parameters_by_path()`, `get_database_config()`, `get_api_config()`
- Use `decrypt=True` for SecureString parameters

**Node.js** (`examples/lambda/config_loader.js`):
- Uses AWS SDK v3 (`@aws-sdk/client-ssm`)
- In-memory Map-based caching
- Async/await pattern throughout

Both implementations are production-ready and can be copied directly into Lambda functions.

## Common Workflows

### Adding a New Parameter

1. Edit `configs/dev/parameters.tfvars` (or stg/prd)
2. Add parameter to the `parameters` map
3. Validate: `python3 scripts/validate-config.py configs/dev/parameters.tfvars`
4. Deploy: `./scripts/deploy.sh dev`
5. Verify: `./scripts/get-parameter.sh dev your/new/parameter`

### Adding a New Environment

1. Create `configs/{new-env}/` directory
2. Copy `backend.tfvars` from an existing environment (e.g., dev) and update the key path
3. Copy `parameters.tfvars` from an existing environment and update environment-specific values
4. Update `environment` validation in `terraform/variables.tf` to include new env
5. Deploy: `./scripts/deploy.sh {new-env}`

### Rotating a Secret

1. Update the value in `configs/{env}/parameters.tfvars`
2. Deploy: `./scripts/deploy.sh {env}`
3. Terraform will update the parameter in place
4. Lambda functions using caching may need to be restarted or wait for cache expiry

### Granting Lambda Access to Parameters

After deploying parameters, attach the generated IAM policy to your Lambda's execution role:

```bash
# Get policy ARN
cd terraform && terraform output lambda_ssm_read_policy_arn

# Attach to Lambda role
aws iam attach-role-policy \
  --role-name your-lambda-execution-role \
  --policy-arn arn:aws:iam::123456789012:policy/gadgetcloud-lambda-ssm-read-dev
```

## Important Notes

- **Never commit** actual `.tfvars` files - they contain secrets. Only `.example` files are tracked.
- **SecureString parameters** require `decrypt=True` when retrieving in Lambda, and Lambda needs `kms:Decrypt` permission.
- **Parameter caching** in Lambda: Both example loaders cache parameters. Clear cache by restarting function or use short TTLs for frequently-changing values.
- **Cost**: Standard tier is free up to 10,000 parameters. KMS encryption/decryption incurs per-operation charges.
- **Parameter limits**: Standard tier max 4KB per parameter. Use `tier = "Advanced"` for larger values (up to 8KB).
