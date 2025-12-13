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

**Current Status**: All environments deployed with 40 parameters each
- **AWS Profile**: `gc`
- **Region**: ap-south-1 (Mumbai)
- **Backend**: S3 (`tf-state.gadgetcloud.io`)
- **Email Templates**: Managed in separate files (`configs/templates/email/`)

## Architecture

### Parameter Naming Pattern

```
/gadgetcloud/{environment}/{category}/{parameter-name}
```

Examples:
- `/gadgetcloud/dev/api/base_url`
- `/gadgetcloud/prd/email/from_address`
- `/gadgetcloud/stg/features/enable_analytics`

### Three-Layer Configuration

**Email templates** (`terraform/email-templates.tf`):
- Email templates loaded from separate files in `configs/templates/email/`
- Uses Terraform's `file()` function for clean separation
- Defined in `local.email_templates`

**Shared config** (`configs/common.tfvars`):
- Feature flags, rate limits, form templates
- Same across all environments
- Uses `common_parameters` variable

**Environment-specific** (`configs/{env}/parameters.tfvars`):
- Values that differ per environment (e.g., API URLs)
- Uses `environment_parameters` variable
- Overrides common and email template parameters if conflicts exist

**Merge strategy** (`terraform/ssm.tf:3-5`):
```hcl
locals {
  all_parameters = merge(local.email_templates, var.common_parameters, var.environment_parameters, var.parameters)
}
```
Priority (last wins): email_templates < common_parameters < environment_parameters < parameters (legacy)

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

Email templates are stored in separate files for easier editing and management.

### Template Structure

Each template type has three files (`subject.txt`, `html.html`, `text.txt`):

```
configs/templates/email/
├── contact-confirmation/
│   ├── subject.txt
│   ├── html.html
│   └── text.txt
├── password-reset/
├── email-verification/
├── account-deletion/
└── notification/
```

**Available templates**:
- `email/contact-confirmation/*` - Thank you message for contact form submissions
- `email/password-reset/*` - Password reset with verification code
- `email/email-verification/*` - Email address verification for new accounts
- `email/account-deletion/*` - Account deletion confirmation with grace period
- `email/notification/*` - Generic notification template

### Adding a New Email Template

1. Create template files:
   ```bash
   mkdir -p configs/templates/email/new-template
   # Create subject.txt, html.html, text.txt
   ```

2. Add to `terraform/email-templates.tf`:
   ```hcl
   "email/new-template/subject" = {
     value       = file("${path.module}/../configs/templates/email/new-template/subject.txt")
     type        = "String"
     description = "New template subject"
   }
   # ... add html and text entries
   ```

3. Deploy: `./scripts/deploy.sh dev`

### Editing Email Templates

Simply edit the template files in `configs/templates/email/` and redeploy:

```bash
# Edit the template
vim configs/templates/email/password-reset/html.html

# Deploy changes
./scripts/deploy.sh dev
```

### Template Variables

Templates use `{variable}` syntax for dynamic content:

```python
# Python example
template = config.get_parameter('email/password-reset/html')
email = template.format(
    user_name="John",
    reset_link="https://...",
    verification_code="123456",
    support_email="support@gadgetcloud.io"
)
```

**Common variables**:
- `{user_name}` - User's name
- `{email}` - User's email address
- `{support_email}` - Support contact email
- Template-specific: `{reset_link}`, `{verification_link}`, `{ticket_id}`, `{deletion_date}`, etc.

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
│   ├── main.tf              # Provider and S3 backend
│   ├── variables.tf         # Input variables (common_parameters, environment_parameters)
│   ├── ssm.tf               # SSM parameters, KMS key, IAM policy (merge logic at line 4)
│   ├── email-templates.tf   # Email template definitions using file() function
│   └── outputs.tf           # Exports (parameter ARNs, KMS key, policy ARN)
├── configs/
│   ├── common.tfvars        # Shared parameters (feature flags, form templates)
│   ├── templates/
│   │   └── email/           # Email template files (subject.txt, html.html, text.txt)
│   │       ├── contact-confirmation/
│   │       ├── password-reset/
│   │       ├── email-verification/
│   │       ├── account-deletion/
│   │       └── notification/
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
│   ├── deploy.sh            # Main deployment script
│   ├── validate-config.py   # Configuration validation
│   ├── list-parameters.sh   # List parameters in AWS
│   └── get-parameter.sh     # Get parameter value from AWS
└── examples/lambda/
    ├── config_loader.py     # Python loader with caching
    └── config_loader.js     # Node.js loader with caching
```

## Important Notes

- **AWS Account**: 860154085634 (ap-south-1 region)
- **Python 3.x required**: For `validate-config.py` script
- **Never commit** actual secrets to git - only `.example` files are tracked
- **SecureString** parameters require `decrypt=True` when reading in Lambda
- **Parameter caching**: Example loaders cache values - restart Lambda to clear
- **Cost**: Standard tier free up to 10,000 params; Advanced tier for >4KB values
- **Validation**: Always run `validate-config.py` before deploying to catch `CHANGE_ME` placeholders and misclassified secrets
- **Merge priority**: Email templates are loaded first, then common parameters, then environment-specific parameters. Legacy `var.parameters` variable is deprecated but still supported for backward compatibility (terraform/variables.tf:44-54)
- **Email templates**: Stored as separate files in `configs/templates/email/` for easier editing with syntax highlighting. Loaded via Terraform's `file()` function in `terraform/email-templates.tf`
- **tfplan file**: The deploy script creates `terraform/tfplan` during deployment - this is gitignored and automatically cleaned up
