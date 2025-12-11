variable "environment" {
  description = "Environment name (dev, stg, prd)"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "prd"], var.environment)
    error_message = "Environment must be dev, stg, or prd."
  }
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "gadgetcloud"
}

variable "common_parameters" {
  description = "Common SSM parameters shared across all environments"
  type = map(object({
    value       = string
    type        = string # String, StringList, or SecureString
    description = string
    tier        = optional(string, "Standard") # Standard or Advanced
  }))
  default = {}
}

variable "environment_parameters" {
  description = "Environment-specific SSM parameters"
  type = map(object({
    value       = string
    type        = string # String, StringList, or SecureString
    description = string
    tier        = optional(string, "Standard") # Standard or Advanced
  }))
  default = {}
}

# Legacy variable for backward compatibility - deprecated
variable "parameters" {
  description = "Map of SSM parameters to create (deprecated - use common_parameters and environment_parameters instead)"
  type = map(object({
    value       = string
    type        = string # String, StringList, or SecureString
    description = string
    tier        = optional(string, "Standard") # Standard or Advanced
  }))
  default = {}
}

variable "kms_key_id" {
  description = "KMS key ID for encrypting SecureString parameters"
  type        = string
  default     = null
}
