#!/bin/bash
set -e

# Deploy SSM parameters for a specific environment
# Usage: ./scripts/deploy.sh <environment>

ENVIRONMENT=${1:-dev}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TERRAFORM_DIR="$PROJECT_ROOT/terraform"
CONFIG_DIR="$PROJECT_ROOT/configs/$ENVIRONMENT"

if [[ ! "$ENVIRONMENT" =~ ^(dev|stg|prd)$ ]]; then
    echo "Error: Invalid environment. Must be dev, stg, or prd"
    exit 1
fi

if [ ! -f "$CONFIG_DIR/parameters.tfvars" ]; then
    echo "Error: Configuration file not found: $CONFIG_DIR/parameters.tfvars"
    echo "Copy parameters.tfvars.example to parameters.tfvars and update values"
    exit 1
fi

echo "Deploying SSM parameters for environment: $ENVIRONMENT"
echo "================================================"

cd "$TERRAFORM_DIR"

# Initialize Terraform
if [ -f "$CONFIG_DIR/backend.tfvars" ]; then
    echo "Initializing Terraform with backend config..."
    terraform init -backend-config="$CONFIG_DIR/backend.tfvars" -reconfigure
else
    echo "Warning: No backend config found. Using local state."
    terraform init
fi

# Plan
echo ""
echo "Planning changes..."
terraform plan -var-file="$CONFIG_DIR/parameters.tfvars" -out=tfplan

# Apply
echo ""
read -p "Apply these changes? (yes/no): " confirm
if [ "$confirm" = "yes" ]; then
    terraform apply tfplan
    rm -f tfplan
    echo ""
    echo "Deployment complete!"
else
    echo "Deployment cancelled"
    rm -f tfplan
    exit 1
fi
