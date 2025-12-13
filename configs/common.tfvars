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
  # account-deletion, notification) are now managed in terraform/email-templates.tf
  # This allows for cleaner separation and easier template management.

  # Forms Service Email Templates
  # These templates are used by gc-py-forms-svc for form submission notifications

  # Contact Form Templates
  "forms/email-templates/contacts/subject" = {
    value       = "New Contact Form - {email}"
    type        = "String"
    description = "Contact form notification subject"
  }
  "forms/email-templates/contacts/autoReply" = {
    value       = "true"
    type        = "String"
    description = "Whether to send auto-reply for contact forms"
  }
  "forms/email-templates/contacts/autoReplySubject" = {
    value       = "Thank you for contacting GadgetCloud"
    type        = "String"
    description = "Contact form auto-reply email subject"
  }
  "forms/email-templates/contacts/autoReplyMessage" = {
    value       = "Thank you for reaching out to GadgetCloud! We have received your message and will get back to you within 24-48 hours."
    type        = "String"
    description = "Contact form auto-reply email message"
  }

  # Feedback Form Templates
  "forms/email-templates/feedback/subject" = {
    value       = "New Feedback - {email}"
    type        = "String"
    description = "Feedback form notification subject"
  }
  "forms/email-templates/feedback/autoReply" = {
    value       = "true"
    type        = "String"
    description = "Whether to send auto-reply for feedback forms"
  }
  "forms/email-templates/feedback/autoReplySubject" = {
    value       = "Thank you for your feedback"
    type        = "String"
    description = "Feedback form auto-reply email subject"
  }
  "forms/email-templates/feedback/autoReplyMessage" = {
    value       = "Thank you for sharing your feedback with GadgetCloud! Your input helps us improve our services. We appreciate you taking the time to let us know your thoughts."
    type        = "String"
    description = "Feedback form auto-reply email message"
  }

  # Survey Form Templates
  "forms/email-templates/survey/subject" = {
    value       = "New Survey Response - {email}"
    type        = "String"
    description = "Survey form notification subject"
  }
  "forms/email-templates/survey/autoReply" = {
    value       = "true"
    type        = "String"
    description = "Whether to send auto-reply for survey forms"
  }
  "forms/email-templates/survey/autoReplySubject" = {
    value       = "Thank you for completing our survey"
    type        = "String"
    description = "Survey form auto-reply email subject"
  }
  "forms/email-templates/survey/autoReplyMessage" = {
    value       = "Thank you for completing our survey! Your responses have been recorded and will help us better understand and serve our customers."
    type        = "String"
    description = "Survey form auto-reply email message"
  }

  # Service Request Form Templates
  "forms/email-templates/serviceRequests/subject" = {
    value       = "New Service Request - {email}"
    type        = "String"
    description = "Service request form notification subject"
  }
  "forms/email-templates/serviceRequests/autoReply" = {
    value       = "true"
    type        = "String"
    description = "Whether to send auto-reply for service request forms"
  }
  "forms/email-templates/serviceRequests/autoReplySubject" = {
    value       = "We received your service request"
    type        = "String"
    description = "Service request auto-reply email subject"
  }
  "forms/email-templates/serviceRequests/autoReplyMessage" = {
    value       = "Thank you for contacting GadgetCloud! We have received your service request and will get back to you within 24 hours."
    type        = "String"
    description = "Service request auto-reply email message"
  }
}
