# Templates loaded from external files
# This allows for easier management and editing of email and forms templates

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

  forms_templates = {
    # Contact Form Templates
    "forms/email-templates/contacts/subject" = {
      value       = file("${path.module}/../configs/templates/forms/contacts/subject.txt")
      type        = "String"
      description = "Contact form notification subject"
    }
    "forms/email-templates/contacts/autoReply" = {
      value       = file("${path.module}/../configs/templates/forms/contacts/autoReply.txt")
      type        = "String"
      description = "Whether to send auto-reply for contact forms"
    }
    "forms/email-templates/contacts/autoReplySubject" = {
      value       = file("${path.module}/../configs/templates/forms/contacts/autoReplySubject.txt")
      type        = "String"
      description = "Contact form auto-reply email subject"
    }
    "forms/email-templates/contacts/autoReplyMessage" = {
      value       = file("${path.module}/../configs/templates/forms/contacts/autoReplyMessage.txt")
      type        = "String"
      description = "Contact form auto-reply email message"
    }

    # Feedback Form Templates
    "forms/email-templates/feedback/subject" = {
      value       = file("${path.module}/../configs/templates/forms/feedback/subject.txt")
      type        = "String"
      description = "Feedback form notification subject"
    }
    "forms/email-templates/feedback/autoReply" = {
      value       = file("${path.module}/../configs/templates/forms/feedback/autoReply.txt")
      type        = "String"
      description = "Whether to send auto-reply for feedback forms"
    }
    "forms/email-templates/feedback/autoReplySubject" = {
      value       = file("${path.module}/../configs/templates/forms/feedback/autoReplySubject.txt")
      type        = "String"
      description = "Feedback form auto-reply email subject"
    }
    "forms/email-templates/feedback/autoReplyMessage" = {
      value       = file("${path.module}/../configs/templates/forms/feedback/autoReplyMessage.txt")
      type        = "String"
      description = "Feedback form auto-reply email message"
    }

    # Survey Form Templates
    "forms/email-templates/survey/subject" = {
      value       = file("${path.module}/../configs/templates/forms/survey/subject.txt")
      type        = "String"
      description = "Survey form notification subject"
    }
    "forms/email-templates/survey/autoReply" = {
      value       = file("${path.module}/../configs/templates/forms/survey/autoReply.txt")
      type        = "String"
      description = "Whether to send auto-reply for survey forms"
    }
    "forms/email-templates/survey/autoReplySubject" = {
      value       = file("${path.module}/../configs/templates/forms/survey/autoReplySubject.txt")
      type        = "String"
      description = "Survey form auto-reply email subject"
    }
    "forms/email-templates/survey/autoReplyMessage" = {
      value       = file("${path.module}/../configs/templates/forms/survey/autoReplyMessage.txt")
      type        = "String"
      description = "Survey form auto-reply email message"
    }

    # Service Request Form Templates
    "forms/email-templates/serviceRequests/subject" = {
      value       = file("${path.module}/../configs/templates/forms/serviceRequests/subject.txt")
      type        = "String"
      description = "Service request form notification subject"
    }
    "forms/email-templates/serviceRequests/autoReply" = {
      value       = file("${path.module}/../configs/templates/forms/serviceRequests/autoReply.txt")
      type        = "String"
      description = "Whether to send auto-reply for service request forms"
    }
    "forms/email-templates/serviceRequests/autoReplySubject" = {
      value       = file("${path.module}/../configs/templates/forms/serviceRequests/autoReplySubject.txt")
      type        = "String"
      description = "Service request auto-reply email subject"
    }
    "forms/email-templates/serviceRequests/autoReplyMessage" = {
      value       = file("${path.module}/../configs/templates/forms/serviceRequests/autoReplyMessage.txt")
      type        = "String"
      description = "Service request auto-reply email message"
    }
  }
}
