# Email templates loaded from external files
# This allows for easier management and editing of email templates

locals {
  email_templates = {
    # Contact Confirmation
    "email/contact-confirmation/subject" = {
      value       = file("${path.module}/../configs/templates/email/contact-confirmation/subject.txt")
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
      value       = file("${path.module}/../configs/templates/email/password-reset/subject.txt")
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
      value       = file("${path.module}/../configs/templates/email/email-verification/subject.txt")
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
      value       = file("${path.module}/../configs/templates/email/account-deletion/subject.txt")
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
      value       = file("${path.module}/../configs/templates/email/notification/subject.txt")
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
}
