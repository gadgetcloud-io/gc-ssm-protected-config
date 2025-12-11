#!/usr/bin/env python3
"""
Validate parameter configuration files before deployment
"""
import sys
import re
from pathlib import Path


def validate_tfvars(file_path):
    """Validate a .tfvars file for common issues"""
    errors = []
    warnings = []

    with open(file_path, 'r') as f:
        content = f.read()

    # Check for CHANGE_ME placeholders
    if 'CHANGE_ME' in content:
        errors.append("Found CHANGE_ME placeholder values that must be replaced")

    # Check for obvious secrets in non-SecureString parameters
    lines = content.split('\n')
    in_parameter = False
    current_param = {}

    for line in lines:
        line = line.strip()

        if '= {' in line:
            in_parameter = True
            current_param = {'name': line.split('"')[1] if '"' in line else 'unknown'}
        elif in_parameter:
            if 'type' in line:
                current_param['type'] = line.split('"')[1] if '"' in line else None
            elif 'value' in line:
                current_param['value'] = line.split('"')[1] if '"' in line else None
            elif '}' in line:
                # Check if parameter looks like a secret but isn't SecureString
                if current_param.get('type') != 'SecureString':
                    name_lower = current_param.get('name', '').lower()
                    if any(keyword in name_lower for keyword in ['password', 'secret', 'key', 'token']):
                        warnings.append(
                            f"Parameter '{current_param.get('name')}' looks like a secret "
                            "but is not using type 'SecureString'"
                        )
                in_parameter = False
                current_param = {}

    return errors, warnings


def main():
    if len(sys.argv) < 2:
        print("Usage: validate-config.py <path-to-tfvars-file>")
        sys.exit(1)

    file_path = Path(sys.argv[1])

    if not file_path.exists():
        print(f"Error: File not found: {file_path}")
        sys.exit(1)

    print(f"Validating {file_path}...")
    errors, warnings = validate_tfvars(file_path)

    if warnings:
        print("\nWarnings:")
        for warning in warnings:
            print(f"  ⚠️  {warning}")

    if errors:
        print("\nErrors:")
        for error in errors:
            print(f"  ❌ {error}")
        print("\nValidation failed!")
        sys.exit(1)
    else:
        print("\n✅ Validation passed!")
        sys.exit(0)


if __name__ == '__main__':
    main()
