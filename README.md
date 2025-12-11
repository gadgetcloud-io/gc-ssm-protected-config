# Gadgetcloud.io SSM Protected Configuration

Central configuration management for Gadgetcloud.io microservices using AWS Systems Manager (SSM) Parameter Store.

## 🚀 Deployment Status

| Environment | Status | Parameters | Region |
|------------|--------|------------|---------|
| **dev** | ✅ Deployed | 18 parameters | ap-south-1 |
| **stg** | ✅ Deployed | 18 parameters | ap-south-1 |
| **prd** | ✅ Deployed | 18 parameters | ap-south-1 |

**AWS Profile**: `gc` | **S3 Backend**: `tf-state.gadgetcloud.io`

## Overview

This repository manages configuration parameters for all Gadgetcloud.io Lambda microservices across multiple environments (dev, stg, prd). Parameters are stored securely in AWS SSM Parameter Store with encryption for sensitive values using KMS.

## Project Structure

```
.
├── terraform/              # Terraform infrastructure code
│   ├── main.tf            # Provider and backend configuration
│   ├── variables.tf       # Input variables
│   ├── ssm.tf             # SSM parameters and KMS key resources
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

### Configuration Structure

**Common Parameters** (`configs/common.tfvars`):
- Shared across all environments (dev, stg, prd)
- Includes: email templates, feature flags, rate limits, email config
- Reduces redundancy and ensures consistency

**Environment-Specific Parameters** (`configs/{env}/parameters.tfvars`):
- Contains only environment-specific values
- Currently only `api/base_url` differs between environments
- Automatically merged with common parameters during deployment

## Parameter Naming Convention

All parameters follow this pattern:
```
/gadgetcloud/{environment}/{category}/{parameter-name}
```

Examples:
- `/gadgetcloud/dev/database/host`
- `/gadgetcloud/prd/api/base_url`
- `/gadgetcloud/stg/features/enable_analytics`

## Email Templates

The system includes pre-configured email templates stored in SSM Parameter Store:

### Template Categories

**Contact Confirmation** - "Thank you for contacting us"
- `email/contact-confirmation/subject` - Email subject line
- `email/contact-confirmation/html` - HTML email template
- `email/contact-confirmation/text` - Plain text version

**Password Reset** - Secure password reset emails
- `email/password-reset/subject` - Email subject line
- `email/password-reset/html` - HTML email template with reset link
- `email/password-reset/text` - Plain text version

**Notification** - Generic notification emails
- `email/notification/subject` - Email subject line
- `email/notification/html` - HTML email template
- `email/notification/text` - Plain text version

### Email Configuration
- `email/from_address` - Default sender email (noreply@gadgetcloud.io)
- `email/from_name` - Default sender name (GadgetCloud)
- `email/support_email` - Support contact email

### Template Variables

Templates use single-brace `{variable}` syntax for dynamic content:

**Contact Confirmation**:
- `{user_name}` - Recipient name
- `{email}` - User's email address
- `{ticket_id}` - Support ticket identifier
- `{support_email}` - Support email address

**Password Reset**:
- `{user_name}` - Recipient name
- `{email}` - Account email
- `{reset_link}` - Password reset URL
- `{verification_code}` - Verification code
- `{support_email}` - Support email address

**Notification**:
- `{user_name}` - Recipient name
- `{notification_title}` - Notification heading
- `{notification_message}` - Main message content
- `{action_url}` - Call-to-action link
- `{action_text}` - Button text
- `{support_email}` - Support email address

### Usage in Lambda

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

// Replace template variables (using simple string replace or template library)
const emailHtml = htmlTemplate
    .replace('{user_name}', 'John Doe')
    .replace('{email}', 'john@example.com')
    .replace('{reset_link}', 'https://app.gadgetcloud.io/reset?token=xyz')
    .replace('{verification_code}', '123456')
    .replace('{support_email}', await config.getParameter('email/support_email'));
```

## Getting Started

### Prerequisites

- AWS CLI configured with profile `gc`
- Terraform >= 1.0
- Python 3.x (for validation script)
- AWS Account: 860154085634
- AWS Region: ap-south-1 (Mumbai)

### Quick Start

The environments are already deployed! To use the configuration:

1. **List parameters**:
   ```bash
   ./scripts/list-parameters.sh dev
   ./scripts/list-parameters.sh stg
   ./scripts/list-parameters.sh prd
   ```

2. **Get a parameter value**:
   ```bash
   ./scripts/get-parameter.sh dev api/base_url
   ```

3. **Update a parameter** (edit and redeploy):
   ```bash
   vim configs/dev/parameters.tfvars
   ./scripts/deploy.sh dev
   ```

### Initial Setup (If Starting Fresh)

1. **Configure AWS CLI**:
   ```bash
   aws configure --profile gc
   # Enter credentials and set region to ap-south-1
   ```

2. **Update parameters for your environment**:
   ```bash
   vim configs/dev/parameters.tfvars
   ```

3. **Validate configuration**:
   ```bash
   python3 scripts/validate-config.py configs/dev/parameters.tfvars
   ```

4. **Deploy parameters**:
   ```bash
   ./scripts/deploy.sh dev
   ```

## Common Tasks

### Deploy Configuration Changes

```bash
# Deploy to dev environment
./scripts/deploy.sh dev

# Deploy to stg
./scripts/deploy.sh stg

# Deploy to prd
./scripts/deploy.sh prd
```

### List All Parameters

```bash
# List all dev parameters
./scripts/list-parameters.sh dev

# List all prd parameters
./scripts/list-parameters.sh prd
```

### Retrieve a Parameter Value

```bash
# Get a plain text parameter
./scripts/get-parameter.sh dev database/host

# Get and decrypt a secure parameter
./scripts/get-parameter.sh prd database/password --decrypt
```

### Manual Terraform Operations

```bash
cd terraform

# Initialize with backend
terraform init -backend-config=../configs/dev/backend.tfvars

# Plan changes
terraform plan -var-file=../configs/dev/parameters.tfvars

# Apply changes
terraform apply -var-file=../configs/dev/parameters.tfvars

# Destroy all parameters (use with caution!)
terraform destroy -var-file=../configs/dev/parameters.tfvars
```

## Lambda Integration

Lambda functions need IAM permissions to read SSM parameters. The Terraform configuration creates an IAM policy that can be attached to Lambda execution roles.

### Attach Policy to Lambda Role

```bash
# Get the policy ARN from Terraform outputs
cd terraform
terraform output lambda_ssm_read_policy_arn

# Attach to your Lambda role
aws iam attach-role-policy \
  --role-name your-lambda-role-name \
  --policy-arn <policy-arn-from-output>
```

### Using Configuration in Lambda Functions

See the example implementations in `examples/lambda/`:

- **Python**: `config_loader.py` - Includes caching and helper methods
- **Node.js**: `config_loader.js` - Async/await with AWS SDK v3

Example usage:

```python
# Python
from config_loader import ConfigLoader

config = ConfigLoader()
db_config = config.get_database_config()
api_key = config.get_parameter('external/payment_api_key', decrypt=True)
```

```javascript
// Node.js
const { ConfigLoader } = require('./config_loader');

const config = new ConfigLoader();
const dbConfig = await config.getDatabaseConfig();
const apiKey = await config.getParameter('external/payment_api_key', true);
```

## Parameter Types

- **String**: Plain text configuration values
- **StringList**: Comma-separated list values
- **SecureString**: Encrypted values (passwords, API keys, tokens)

Always use `SecureString` for sensitive data like:
- Database passwords
- API keys and tokens
- OAuth secrets
- Encryption keys

## Security Best Practices

1. **Never commit** `.tfvars` files with real values to git
2. **Always use** `SecureString` type for sensitive parameters
3. **Rotate secrets** regularly
4. **Use KMS encryption** for SecureString parameters (automatically configured)
5. **Apply least privilege** - only grant Lambda functions access to parameters they need
6. **Enable CloudTrail** to audit parameter access

## Cost Optimization

- **Standard tier**: Free for up to 10,000 parameters
- **Advanced tier**: Use only when needed (parameters > 4KB or > 10,000 total)
- **KMS encryption**: Charges apply per encryption/decryption operation

## Troubleshooting

### Parameter Not Found Error

Verify the parameter exists:
```bash
./scripts/list-parameters.sh dev
```

Check parameter name format matches: `/gadgetcloud/{env}/{key}`

### Access Denied Error

Ensure Lambda execution role has:
1. `ssm:GetParameter` or `ssm:GetParametersByPath` permission
2. `kms:Decrypt` permission for the KMS key

### Terraform State Issues

If state gets corrupted or lost:
```bash
# Re-import existing parameters (example)
terraform import aws_ssm_parameter.config[\"database/host\"] /gadgetcloud/dev/database/host
```

## Contributing

When adding new parameters:
1. Add to the appropriate environment's `parameters.tfvars`
2. Run validation: `python3 scripts/validate-config.py configs/{env}/parameters.tfvars`
3. Test in dev first: `./scripts/deploy.sh dev`
4. Update documentation if adding new parameter categories
