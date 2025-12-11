#!/bin/bash
set -e

# Get a parameter value from SSM
# Usage: ./scripts/get-parameter.sh <environment> <parameter-key> [--decrypt]

ENVIRONMENT=$1
PARAMETER_KEY=$2
DECRYPT_FLAG=${3:-}

if [ -z "$ENVIRONMENT" ] || [ -z "$PARAMETER_KEY" ]; then
    echo "Usage: $0 <environment> <parameter-key> [--decrypt]"
    echo "Example: $0 dev database/host"
    echo "Example: $0 prod database/password --decrypt"
    exit 1
fi

PARAMETER_NAME="/gadgetcloud/$ENVIRONMENT/$PARAMETER_KEY"

if [ "$DECRYPT_FLAG" = "--decrypt" ]; then
    aws ssm get-parameter --name "$PARAMETER_NAME" --with-decryption --query 'Parameter.Value' --output text
else
    aws ssm get-parameter --name "$PARAMETER_NAME" --query 'Parameter.Value' --output text
fi
