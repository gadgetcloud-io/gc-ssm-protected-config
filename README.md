# Gadgetcloud.io SSM Protected Configuration

Central configuration management for Gadgetcloud.io microservices using AWS Systems Manager (SSM) Parameter Store.

## 🚀 Quick Start

```bash
# Deploy to an environment
./scripts/deploy.sh dev

# List all parameters
./scripts/list-parameters.sh dev

# Get a parameter value
./scripts/get-parameter.sh dev api/base_url
```

## Deployment Status

| Environment | Status | Parameters | Region |
|------------|--------|------------|---------|
| **dev** | ✅ Deployed | 18 parameters | ap-south-1 |
| **stg** | ✅ Deployed | 18 parameters | ap-south-1 |
| **prd** | ✅ Deployed | 18 parameters | ap-south-1 |

**AWS Profile**: `gc` | **S3 Backend**: `tf-state.gadgetcloud.io`

## Overview

This repository manages configuration parameters for all Gadgetcloud.io Lambda microservices across multiple environments (dev, stg, prd). Parameters are stored securely in AWS SSM Parameter Store with KMS encryption for sensitive values.

### Parameter Naming Convention

All parameters follow this pattern:
```
/gadgetcloud/{environment}/{category}/{parameter-name}
```

Examples:
- `/gadgetcloud/dev/api/base_url`
- `/gadgetcloud/prd/email/from_address`
- `/gadgetcloud/stg/features/enable_analytics`

### Configuration Structure

**Shared Parameters** (`configs/common.tfvars`):
- Email templates, feature flags, rate limits
- Same across all environments
- Reduces redundancy and ensures consistency

**Environment-Specific Parameters** (`configs/{env}/parameters.tfvars`):
- Values that differ per environment (e.g., API URLs)
- Automatically merged with common parameters during deployment
- Environment-specific values override common values
- **Merge priority** (last wins): common_parameters < environment_parameters < parameters (legacy, deprecated)

## Common Tasks

### Deploy Configuration Changes

```bash
# Deploy to dev
./scripts/deploy.sh dev

# Deploy to staging
./scripts/deploy.sh stg

# Deploy to production
./scripts/deploy.sh prd
```

### Validate Configuration

```bash
# Validates both common.tfvars and environment-specific parameters.tfvars
python3 scripts/validate-config.py dev
python3 scripts/validate-config.py stg
python3 scripts/validate-config.py prd
```

Checks for:
- `CHANGE_ME` placeholders that need replacing
- Sensitive parameters not using `SecureString` type

### Query Parameters

```bash
# List all parameters for an environment
./scripts/list-parameters.sh dev

# Get a parameter value
./scripts/get-parameter.sh dev email/from_address

# Get and decrypt a secure parameter
./scripts/get-parameter.sh prd database/password --decrypt
```

## Adding New Parameters

### Shared Parameters (same across all environments)

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
4. Deploy to all environments:
   ```bash
   ./scripts/deploy.sh dev
   ./scripts/deploy.sh stg
   ./scripts/deploy.sh prd
   ```

### Environment-Specific Parameters

1. Edit `configs/dev/parameters.tfvars` (and stg/prd as needed)
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

## Email Templates

The system includes pre-configured email templates stored in SSM Parameter Store.

### Available Templates

Each template has three parameters: `/subject`, `/html`, `/text`

- **contact-confirmation** - "Thank you for contacting us"
- **password-reset** - Secure password reset emails with links
- **notification** - Generic notification emails

### Template Variables

Templates use `{variable}` syntax for dynamic content:

**Common variables:**
- `{user_name}`, `{email}`, `{support_email}`

**Password reset:**
- `{reset_link}`, `{verification_code}`

**Contact confirmation:**
- `{ticket_id}`

**Notification:**
- `{notification_title}`, `{notification_message}`, `{action_url}`, `{action_text}`

### Usage Example

```python
# Python - Load and render email template
from config_loader import ConfigLoader

config = ConfigLoader()
html_template = config.get_parameter('email/password-reset/html')
subject = config.get_parameter('email/password-reset/subject')

# Replace template variables
email_html = html_template.format(
    user_name="John Doe",
    email="john@example.com",
    reset_link="https://app.gadgetcloud.io/reset?token=xyz",
    verification_code="123456",
    support_email=config.get_parameter('email/support_email')
)
```

```javascript
// Node.js - Load and render email template
const { ConfigLoader } = require('./config_loader');

const config = new ConfigLoader();
const htmlTemplate = await config.getParameter('email/password-reset/html');
const subject = await config.getParameter('email/password-reset/subject');

// Replace template variables
const emailHtml = htmlTemplate
    .replace('{user_name}', 'John Doe')
    .replace('{email}', 'john@example.com')
    .replace('{reset_link}', 'https://app.gadgetcloud.io/reset?token=xyz')
    .replace('{verification_code}', '123456')
    .replace('{support_email}', await config.getParameter('email/support_email'));
```

## Lambda Integration

### Attach IAM Policy to Lambda Role

```bash
# Get the policy ARN from Terraform outputs
cd terraform
terraform output lambda_ssm_read_policy_arn

# Attach to your Lambda role
aws iam attach-role-policy \
  --role-name your-lambda-role-name \
  --policy-arn <policy-arn-from-output> \
  --profile gc
```

### Use Configuration in Lambda Functions

**Python** (`examples/lambda/config_loader.py`):
```python
from config_loader import ConfigLoader

config = ConfigLoader()
db_config = config.get_database_config()
api_key = config.get_parameter('external/payment_api_key', decrypt=True)
```

**Node.js** (`examples/lambda/config_loader.js`):
```javascript
const { ConfigLoader } = require('./config_loader');

const config = new ConfigLoader();
const dbConfig = await config.getDatabaseConfig();
const apiKey = await config.getParameter('external/payment_api_key', true);
```

Both implementations include built-in caching for performance.

## Direct Terraform Operations

```bash
cd terraform

# Initialize with backend
terraform init -backend-config=../configs/dev/backend.tfvars -reconfigure

# Plan changes (must include both common and environment-specific files)
terraform plan \
  -var-file=../configs/common.tfvars \
  -var-file=../configs/dev/parameters.tfvars

# Apply changes
terraform apply \
  -var-file=../configs/common.tfvars \
  -var-file=../configs/dev/parameters.tfvars

# View outputs
terraform output

# Import existing parameter
terraform import 'aws_ssm_parameter.config["api/base_url"]' /gadgetcloud/dev/api/base_url
```

## Project Structure

```
.
├── terraform/              # Terraform infrastructure code
│   ├── main.tf            # Provider and backend configuration
│   ├── variables.tf       # Input variables
│   ├── ssm.tf             # SSM parameters, KMS key, IAM policy
│   └── outputs.tf         # Outputs (parameter ARNs, KMS key, etc.)
├── configs/               # Configuration files
│   ├── common.tfvars      # Shared parameters (all environments)
│   ├── dev/
│   │   ├── backend.tfvars # S3 backend config for dev
│   │   └── parameters.tfvars  # Dev-specific parameters only
│   ├── stg/
│   │   ├── backend.tfvars # S3 backend config for stg
│   │   └── parameters.tfvars  # Stg-specific parameters only
│   └── prd/
│       ├── backend.tfvars # S3 backend config for prd
│       └── parameters.tfvars  # Prd-specific parameters only
├── scripts/               # Helper scripts
│   ├── deploy.sh          # Deploy parameters for an environment
│   ├── get-parameter.sh   # Retrieve a parameter value
│   ├── list-parameters.sh # List all parameters for an environment
│   └── validate-config.py # Validate configuration files
└── examples/              # Example code for Lambda functions
    └── lambda/
        ├── config_loader.py  # Python configuration loader
        └── config_loader.js  # Node.js configuration loader
```

## Security Best Practices

- ✅ **Never commit** `.tfvars` files with real values to git
- ✅ **Always use** `SecureString` type for sensitive parameters
- ✅ **Rotate secrets** regularly
- ✅ **Use KMS encryption** for SecureString parameters (automatically configured)
- ✅ **Apply least privilege** - only grant Lambda functions access to parameters they need
- ✅ **Validate before deploying** to catch security issues

## Parameter Types

- **String**: Plain text configuration values
- **StringList**: Comma-separated list values
- **SecureString**: Encrypted values (passwords, API keys, tokens)

Always use `SecureString` for:
- Database passwords
- API keys and tokens
- OAuth secrets
- Encryption keys

## Prerequisites

- **AWS CLI** configured with profile `gc`
- **Terraform** >= 1.0
- **Python 3.x** (required for `validate-config.py` script)
- **AWS Account**: 860154085634
- **AWS Region**: ap-south-1 (Mumbai)

## Cost Optimization

- **Standard tier**: Free for up to 10,000 parameters
- **Advanced tier**: Use only when needed (parameters > 4KB or > 10,000 total)
- **KMS encryption**: Charges apply per encryption/decryption operation

## Troubleshooting

### Parameter Not Found

```bash
# Verify parameter exists
./scripts/list-parameters.sh dev

# Check parameter name format matches: /gadgetcloud/{env}/{key}
```

### Access Denied Error

Ensure Lambda execution role has:
1. `ssm:GetParameter` or `ssm:GetParametersByPath` permission
2. `kms:Decrypt` permission for the KMS key

### Terraform State Issues

```bash
# Re-import existing parameters if needed
terraform import 'aws_ssm_parameter.config["database/host"]' /gadgetcloud/dev/database/host
```

## Contributing

When adding new parameters:
1. Add to `configs/common.tfvars` for shared parameters, or to `configs/{env}/parameters.tfvars` for environment-specific values
2. Run validation: `python3 scripts/validate-config.py dev` (or stg/prd)
3. Test in dev first: `./scripts/deploy.sh dev`
4. Update documentation if adding new parameter categories

## License

Private - GadgetCloud
