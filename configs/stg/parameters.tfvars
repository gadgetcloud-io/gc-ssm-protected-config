# Environment-specific parameters for stg
# Common parameters are defined in configs/common.tfvars

environment = "stg"

environment_parameters = {
  # API Configuration - Environment Specific
  "api/base_url" = {
    value       = "https://rest-stg.gadgetcloud.io"
    type        = "String"
    description = "Base URL for API services"
  }

  # API Gateway Routes
  "routes/02-auth" = {
    value       = "{\"pattern\":\"^/auth\",\"backend\":\"auth-service\",\"methods\":[\"GET\",\"POST\",\"PUT\",\"DELETE\",\"OPTIONS\"],\"retry_count\":2,\"timeout\":10,\"skip_jwt_validation\":true}"
    type        = "String"
    description = "Authentication service route configuration (JWT validation skipped - handled by auth service itself)"
  }

  # Backend Services
  "backends/auth-service/type" = {
    value       = "lambda"
    type        = "String"
    description = "Authentication service backend type"
  }

  "backends/auth-service/function_name" = {
    value       = "gc-py-common-auth-svc-stg"
    type        = "String"
    description = "Authentication service Lambda function name"
  }
}
