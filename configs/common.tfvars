# Common parameters shared across all environments (dev, stg, prd)
# Environment-specific values should be in configs/{env}/parameters.tfvars

aws_region = "ap-south-1"

common_parameters = {
  # API Configuration
  "api/rate_limit" = {
    value       = "5000"
    type        = "String"
    description = "API rate limit per minute"
  }

  # Feature Flags
  "features/enable_analytics" = {
    value       = "true"
    type        = "String"
    description = "Enable analytics features"
  }
  "features/enable_template_svc" = {
    value       = "true"
    type        = "String"
    description = "Enable template service"
  }
  "features/enable_notifications_svc" = {
    value       = "true"
    type        = "String"
    description = "Enable template service"
  }
  "features/enable_email_svc" = {
    value       = "true"
    type        = "String"
    description = "Enable mail service"
  }

  # Email Configuration
  "email/from_address" = {
    value       = "noreply@gadgetcloud.io"
    type        = "String"
    description = "Default sender email address"
  }
  "email/from_name" = {
    value       = "GadgetCloud"
    type        = "String"
    description = "Default sender name"
  }
  "email/support_email" = {
    value       = "support@gadgetcloud.io"
    type        = "String"
    description = "Support email address"
  }

  # NOTE: Email templates (contact-confirmation, password-reset, email-verification,
  # account-deletion, notification) are now managed in terraform/templates.tf
  # Forms templates (contacts, feedback, survey, serviceRequests) are also in terraform/templates.tf
  # This allows for cleaner separation and easier template management.
}
