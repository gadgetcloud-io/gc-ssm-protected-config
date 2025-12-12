# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Quick Reference

```bash
# Deploy to an environment
./scripts/deploy.sh dev

# Validate configuration
python3 scripts/validate-config.py dev

# List parameters in AWS
./scripts/list-parameters.sh dev

# Get a specific parameter
./scripts/get-parameter.sh dev api/base_url
```

## Project Overview

Central SSM Parameter Store configuration for **Gadgetcloud.io** Lambda microservices. Uses Terraform to manage parameters across dev/stg/prd environments.

**Current Status**: All environments deployed with 18 parameters each
- **AWS Profile**: `gc`
- **Region**: ap-south-1 (Mumbai)
- **Backend**: S3 (`tf-state.gadgetcloud.io`)

## Architecture

### Parameter Naming Pattern

```
/gadgetcloud/{environment}/{category}/{parameter-name}
```

Examples:
- `/gadgetcloud/dev/api/base_url`
- `/gadgetcloud/prd/email/from_address`
- `/gadgetcloud/stg/features/enable_analytics`

### Two-Layer Configuration

**Shared config** (`configs/common.tfvars`):
- Email templates, feature flags, rate limits
- Same across all environments
- Uses `common_parameters` variable

**Environment-specific** (`configs/{env}/parameters.tfvars`):
- Values that differ per environment (e.g., API URLs)
- Uses `environment_parameters` variable
- Overrides common parameters if conflicts exist

**Merge strategy** (`terraform/ssm.tf:4`):
```hcl
locals {
  all_parameters = merge(var.common_parameters, var.environment_parameters, var.parameters)
}
```

### Security

- **KMS Encryption**: Each environment has its own KMS key
- **SecureString**: Use for passwords, tokens, API keys
- **IAM Policy**: Terraform creates `lambda_ssm_read_policy_arn` for Lambda functions
- **Environment Isolation**: dev/stg/prd parameters never overlap

## Common Tasks

### Deploy Changes

```bash
# Deploy to dev (most common)
./scripts/deploy.sh dev

# Deploy to staging
./scripts/deploy.sh stg

# Deploy to production (requires confirmation)
./scripts/deploy.sh prd
```

Script automatically:
1. Loads `configs/common.tfvars` + `configs/{env}/parameters.tfvars`
2. Runs `terraform plan`
3. Prompts for confirmation
4. Applies changes

### Add a Shared Parameter

For parameters **same across all environments**:

1. Edit `configs/common.tfvars`
2. Add to `common_parameters` map:
   ```hcl
   common_parameters = {
     "api/timeout" = {
       value       = "30"
       type        = "String"
       description = "API timeout in seconds"
     }
   }
   ```
3. Validate: `python3 scripts/validate-config.py dev`
4. Deploy to all: `./scripts/deploy.sh dev && ./scripts/deploy.sh stg && ./scripts/deploy.sh prd`

### Add an Environment-Specific Parameter

For parameters **different per environment**:

1. Edit `configs/dev/parameters.tfvars` (and stg/prd)
2. Add to `environment_parameters` map:
   ```hcl
   environment_parameters = {
     "api/base_url" = {
       value       = "https://api-dev.gadgetcloud.io"
       type        = "String"
       description = "API base URL"
     }
   }
   ```
3. Validate: `python3 scripts/validate-config.py dev`
4. Deploy: `./scripts/deploy.sh dev`

### Update a Secret

1. Edit the value in `configs/common.tfvars` or `configs/{env}/parameters.tfvars`
2. Ensure `type = "SecureString"` for sensitive values
3. Deploy: `./scripts/deploy.sh {env}`
4. Restart Lambda functions using caching to pick up new value

### Query Parameters

```bash
# List all parameters for an environment
./scripts/list-parameters.sh dev

# Get a parameter value
./scripts/get-parameter.sh dev email/from_address

# Get and decrypt a SecureString
./scripts/get-parameter.sh prd database/password --decrypt
```

## Email Templates

The repository includes email templates in SSM:

**Template structure** (each has `/subject`, `/html`, `/text`):
- `email/contact-confirmation/*`
- `email/password-reset/*`
- `email/notification/*`

**Template variables** (use `{variable}` syntax):
```python
# Python example
template = config.get_parameter('email/password-reset/html')
email = template.format(
    user_name="John",
    reset_link="https://...",
    verification_code="123456"
)
```

## Lambda Integration

### Attach IAM Policy

```bash
# Get policy ARN
cd terraform && terraform output lambda_ssm_read_policy_arn

# Attach to Lambda role
aws iam attach-role-policy \
  --role-name your-lambda-role \
  --policy-arn <policy-arn-from-output> \
  --profile gc
```

### Use Config Loaders

**Python** (`examples/lambda/config_loader.py`):
```python
from config_loader import ConfigLoader

config = ConfigLoader()
api_url = config.get_parameter('api/base_url')
db_password = config.get_parameter('database/password', decrypt=True)
```

**Node.js** (`examples/lambda/config_loader.js`):
```javascript
const { ConfigLoader } = require('./config_loader');

const config = new ConfigLoader();
const apiUrl = await config.getParameter('api/base_url');
const dbPassword = await config.getParameter('database/password', true);
```

Both implementations include caching via `@lru_cache` (Python) and `Map` (Node.js).

## Direct Terraform Operations

```bash
cd terraform

# Initialize
terraform init -backend-config=../configs/dev/backend.tfvars -reconfigure

# Plan (MUST include both files)
terraform plan \
  -var-file=../configs/common.tfvars \
  -var-file=../configs/dev/parameters.tfvars

# Apply
terraform apply \
  -var-file=../configs/common.tfvars \
  -var-file=../configs/dev/parameters.tfvars

# View outputs
terraform output

# Import existing parameter
terraform import 'aws_ssm_parameter.config["api/base_url"]' /gadgetcloud/dev/api/base_url
```

## File Structure

```
├── terraform/
│   ├── main.tf          # Provider and S3 backend
│   ├── variables.tf     # Input variables (common_parameters, environment_parameters)
│   ├── ssm.tf           # SSM parameters, KMS key, IAM policy (merge logic at line 4)
│   └── outputs.tf       # Exports (parameter ARNs, KMS key, policy ARN)
├── configs/
│   ├── common.tfvars    # Shared parameters (all environments)
│   ├── dev/
│   │   ├── backend.tfvars
│   │   └── parameters.tfvars  # Dev-specific overrides
│   ├── stg/
│   │   ├── backend.tfvars
│   │   └── parameters.tfvars  # Stg-specific overrides
│   └── prd/
│       ├── backend.tfvars
│       └── parameters.tfvars  # Prd-specific overrides
├── scripts/
│   ├── deploy.sh        # Main deployment script
│   ├── validate-config.py
│   ├── list-parameters.sh
│   └── get-parameter.sh
└── examples/lambda/
    ├── config_loader.py  # Python loader with caching
    └── config_loader.js  # Node.js loader with caching
```

## Important Notes

- **Never commit** actual secrets to git - only `.example` files are tracked
- **SecureString** parameters require `decrypt=True` when reading in Lambda
- **Parameter caching**: Example loaders cache values - restart Lambda to clear
- **Cost**: Standard tier free up to 10,000 params; Advanced tier for >4KB values
- **Validation**: Always run `validate-config.py` before deploying to catch `CHANGE_ME` placeholders and misclassified secrets
