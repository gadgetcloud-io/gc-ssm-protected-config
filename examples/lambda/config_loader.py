"""
Example Lambda configuration loader for Gadgetcloud.io
Demonstrates how to load SSM parameters in Lambda functions
"""
import os
import json
import boto3
from functools import lru_cache

ssm_client = boto3.client('ssm')


class ConfigLoader:
    """Load and cache configuration from AWS SSM Parameter Store"""

    def __init__(self, environment=None):
        self.environment = environment or os.environ.get('ENVIRONMENT', 'dev')
        self.project_name = 'gadgetcloud'
        self.base_path = f'/{self.project_name}/{self.environment}'

    @lru_cache(maxsize=128)
    def get_parameter(self, key, decrypt=False):
        """
        Get a single parameter value

        Args:
            key: Parameter key (e.g., 'database/host')
            decrypt: Whether to decrypt SecureString parameters

        Returns:
            Parameter value as string
        """
        parameter_name = f'{self.base_path}/{key}'

        try:
            response = ssm_client.get_parameter(
                Name=parameter_name,
                WithDecryption=decrypt
            )
            return response['Parameter']['Value']
        except ssm_client.exceptions.ParameterNotFound:
            raise ValueError(f"Parameter not found: {parameter_name}")

    @lru_cache(maxsize=32)
    def get_parameters_by_path(self, path, decrypt=False):
        """
        Get all parameters under a path

        Args:
            path: Path prefix (e.g., 'database' or 'api')
            decrypt: Whether to decrypt SecureString parameters

        Returns:
            Dictionary of parameter names to values
        """
        full_path = f'{self.base_path}/{path}'
        parameters = {}

        try:
            paginator = ssm_client.get_paginator('get_parameters_by_path')
            page_iterator = paginator.paginate(
                Path=full_path,
                Recursive=True,
                WithDecryption=decrypt
            )

            for page in page_iterator:
                for param in page['Parameters']:
                    # Remove the base path to get just the key
                    key = param['Name'].replace(f'{self.base_path}/', '')
                    parameters[key] = param['Value']

            return parameters
        except Exception as e:
            raise ValueError(f"Error loading parameters from {full_path}: {str(e)}")

    def get_database_config(self):
        """Get database configuration as a dictionary"""
        db_params = self.get_parameters_by_path('database', decrypt=True)

        return {
            'host': db_params.get('database/host'),
            'port': int(db_params.get('database/port', 5432)),
            'database': db_params.get('database/name'),
            'password': db_params.get('database/password'),
        }

    def get_api_config(self):
        """Get API configuration as a dictionary"""
        api_params = self.get_parameters_by_path('api', decrypt=False)

        return {
            'base_url': api_params.get('api/base_url'),
            'rate_limit': int(api_params.get('api/rate_limit', 1000)),
        }


# Example Lambda handler
def lambda_handler(event, context):
    """Example Lambda function using configuration loader"""

    config = ConfigLoader()

    # Load database config
    db_config = config.get_database_config()
    print(f"Connecting to database: {db_config['host']}")

    # Load API config
    api_config = config.get_api_config()
    print(f"API base URL: {api_config['base_url']}")

    # Get individual parameter
    analytics_enabled = config.get_parameter('features/enable_analytics')
    print(f"Analytics enabled: {analytics_enabled}")

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'Configuration loaded successfully',
            'environment': config.environment
        })
    }
