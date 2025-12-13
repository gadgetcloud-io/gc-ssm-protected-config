# Environment-specific parameters for dev
# Common parameters are defined in configs/common.tfvars

environment = "dev"

environment_parameters = {
  # API Configuration - Environment Specific
  "api/base_url" = {
    value       = "https://rest-stg.gadgetcloud.io"
    type        = "String"
    description = "Base URL for API services"
  }
}
