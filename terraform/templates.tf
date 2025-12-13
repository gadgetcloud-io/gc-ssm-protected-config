# Email and forms templates configuration
# Large templates (HTML/text) are loaded from external files for easier editing
# Small values (subjects, booleans, short messages) are defined inline

locals {
  email_templates = {
    # Contact Confirmation
    "email/contact-confirmation/subject" = {
      value       = "Thank You for Contacting GadgetCloud"
      type        = "String"
      description = "Contact confirmation email subject"
    }
    "email/contact-confirmation/html" = {
      value       = file("${path.module}/../configs/templates/email/contact-confirmation/html.html")
      type        = "String"
      description = "Contact confirmation email HTML template"
    }
    "email/contact-confirmation/text" = {
      value       = file("${path.module}/../configs/templates/email/contact-confirmation/text.txt")
      type        = "String"
      description = "Contact confirmation email plain text template"
    }

    # Password Reset
    "email/password-reset/subject" = {
      value       = "Reset Your GadgetCloud Password"
      type        = "String"
      description = "Password reset email subject"
    }
    "email/password-reset/html" = {
      value       = file("${path.module}/../configs/templates/email/password-reset/html.html")
      type        = "String"
      description = "Password reset email HTML template"
    }
    "email/password-reset/text" = {
      value       = file("${path.module}/../configs/templates/email/password-reset/text.txt")
      type        = "String"
      description = "Password reset email plain text template"
    }

    # Email Verification
    "email/email-verification/subject" = {
      value       = "Verify Your GadgetCloud Email"
      type        = "String"
      description = "Email verification subject"
    }
    "email/email-verification/html" = {
      value       = file("${path.module}/../configs/templates/email/email-verification/html.html")
      type        = "String"
      description = "Email verification HTML template"
    }
    "email/email-verification/text" = {
      value       = file("${path.module}/../configs/templates/email/email-verification/text.txt")
      type        = "String"
      description = "Email verification plain text template"
    }

    # Account Deletion
    "email/account-deletion/subject" = {
      value       = "GadgetCloud Account Deletion Scheduled"
      type        = "String"
      description = "Account deletion confirmation subject"
    }
    "email/account-deletion/html" = {
      value       = file("${path.module}/../configs/templates/email/account-deletion/html.html")
      type        = "String"
      description = "Account deletion confirmation HTML template"
    }
    "email/account-deletion/text" = {
      value       = file("${path.module}/../configs/templates/email/account-deletion/text.txt")
      type        = "String"
      description = "Account deletion confirmation plain text template"
    }

    # Notification
    "email/notification/subject" = {
      value       = "{notification_title} - GadgetCloud"
      type        = "String"
      description = "Notification email subject"
    }
    "email/notification/html" = {
      value       = file("${path.module}/../configs/templates/email/notification/html.html")
      type        = "String"
      description = "Notification email HTML template"
    }
    "email/notification/text" = {
      value       = file("${path.module}/../configs/templates/email/notification/text.txt")
      type        = "String"
      description = "Notification email plain text template"
    }
  }

  forms_templates = {
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
}
