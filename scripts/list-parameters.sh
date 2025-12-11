#!/bin/bash
set -e

# List all parameters for an environment
# Usage: ./scripts/list-parameters.sh <environment>

ENVIRONMENT=${1:-dev}

if [[ ! "$ENVIRONMENT" =~ ^(dev|stg|prd)$ ]]; then
    echo "Error: Invalid environment. Must be dev, stg, or prd"
    exit 1
fi

PATH_PREFIX="/gadgetcloud/$ENVIRONMENT/"

echo "Parameters for environment: $ENVIRONMENT"
echo "========================================"

aws ssm get-parameters-by-path \
    --path "$PATH_PREFIX" \
    --recursive \
    --query 'Parameters[*].[Name,Type,LastModifiedDate]' \
    --output table
