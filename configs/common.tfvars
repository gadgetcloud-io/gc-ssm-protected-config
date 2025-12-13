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

  # Email Template: Contact Confirmation
  "email/contact-confirmation/subject" = {
    value       = "Thank You for Contacting GadgetCloud"
    type        = "String"
    description = "Contact confirmation email subject"
  }
  "email/contact-confirmation/html" = {
    value       = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="background-color: #f8f9fa; padding: 20px; border-radius: 5px;">
          <h1 style="color: #2c3e50; margin-bottom: 20px;">Thank You for Contacting Us</h1>
          <p>Dear {user_name},</p>
          <p>We have received your message and appreciate you reaching out to GadgetCloud. Our team will review your inquiry and respond within 24-48 hours.</p>
          <div style="background-color: #fff; padding: 15px; border-left: 4px solid #3498db; margin: 20px 0;">
            <p style="margin: 0;"><strong>Your Contact Details:</strong></p>
            <p style="margin: 5px 0;">Email: {email}</p>
            <p style="margin: 5px 0;">Ticket ID: {ticket_id}</p>
          </div>
          <p>If you have any urgent concerns, please contact us at {support_email}.</p>
          <p style="margin-top: 30px;">Best regards,<br>The GadgetCloud Team</p>
        </div>
        <div style="text-align: center; margin-top: 20px; color: #7f8c8d; font-size: 12px;">
          <p>&copy; 2025 GadgetCloud. All rights reserved.</p>
        </div>
      </body>
      </html>
    EOT
    type        = "String"
    description = "Contact confirmation email HTML template"
  }
  "email/contact-confirmation/text" = {
    value       = <<-EOT
      Thank You for Contacting Us

      Dear {user_name},

      We have received your message and appreciate you reaching out to GadgetCloud. Our team will review your inquiry and respond within 24-48 hours.

      Your Contact Details:
      - Email: {email}
      - Ticket ID: {ticket_id}

      If you have any urgent concerns, please contact us at {support_email}.

      Best regards,
      The GadgetCloud Team

      © 2025 GadgetCloud. All rights reserved.
    EOT
    type        = "String"
    description = "Contact confirmation email plain text template"
  }

  # Email Template: Password Reset
  "email/password-reset/subject" = {
    value       = "Reset Your GadgetCloud Password"
    type        = "String"
    description = "Password reset email subject"
  }
  "email/password-reset/html" = {
    value       = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="background-color: #f8f9fa; padding: 20px; border-radius: 5px;">
          <h1 style="color: #2c3e50; margin-bottom: 20px;">Password Reset Request</h1>
          <p>Dear {user_name},</p>
          <p>We received a request to reset the password for your GadgetCloud account ({email}).</p>
          <p>Click the button below to reset your password:</p>
          <div style="text-align: center; margin: 30px 0;">
            <a href="{reset_link}" style="background-color: #3498db; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;">Reset Password</a>
          </div>
          <div style="background-color: #fff3cd; padding: 15px; border-left: 4px solid #ffc107; margin: 20px 0;">
            <p style="margin: 0;"><strong>Security Information:</strong></p>
            <p style="margin: 5px 0;">This link will expire in 1 hour.</p>
            <p style="margin: 5px 0;">Verification Code: {verification_code}</p>
          </div>
          <p style="color: #e74c3c;"><strong>Important:</strong> If you did not request a password reset, please ignore this email or contact our support team immediately at {support_email}.</p>
          <p style="margin-top: 30px;">Best regards,<br>The GadgetCloud Team</p>
        </div>
        <div style="text-align: center; margin-top: 20px; color: #7f8c8d; font-size: 12px;">
          <p>&copy; 2025 GadgetCloud. All rights reserved.</p>
        </div>
      </body>
      </html>
    EOT
    type        = "String"
    description = "Password reset email HTML template"
  }
  "email/password-reset/text" = {
    value       = <<-EOT
      Password Reset Request

      Dear {user_name},

      We received a request to reset the password for your GadgetCloud account ({email}).

      Click the link below to reset your password:
      {reset_link}

      Security Information:
      - This link will expire in 1 hour
      - Verification Code: {verification_code}

      IMPORTANT: If you did not request a password reset, please ignore this email or contact our support team immediately at {support_email}.

      Best regards,
      The GadgetCloud Team

      © 2025 GadgetCloud. All rights reserved.
    EOT
    type        = "String"
    description = "Password reset email plain text template"
  }

  # Email Template: Notification
  "email/notification/subject" = {
    value       = "{notification_title} - GadgetCloud"
    type        = "String"
    description = "Notification email subject"
  }
  "email/notification/html" = {
    value       = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="background-color: #f8f9fa; padding: 20px; border-radius: 5px;">
          <h1 style="color: #2c3e50; margin-bottom: 20px;">{notification_title}</h1>
          <p>Dear {user_name},</p>
          <div style="background-color: #fff; padding: 20px; border-radius: 5px; margin: 20px 0;">
            {notification_message}
          </div>
          <div style="text-align: center; margin: 30px 0;">
            <a href="{action_url}" style="background-color: #27ae60; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;">{action_text}</a>
          </div>
          <p>If you have any questions, please contact us at {support_email}.</p>
          <p style="margin-top: 30px;">Best regards,<br>The GadgetCloud Team</p>
        </div>
        <div style="text-align: center; margin-top: 20px; color: #7f8c8d; font-size: 12px;">
          <p>&copy; 2025 GadgetCloud. All rights reserved.</p>
        </div>
      </body>
      </html>
    EOT
    type        = "String"
    description = "Notification email HTML template"
  }
  "email/notification/text" = {
    value       = <<-EOT
      {notification_title}

      Dear {user_name},

      {notification_message}

      Action Link: {action_url}

      If you have any questions, please contact us at {support_email}.

      Best regards,
      The GadgetCloud Team

      © 2025 GadgetCloud. All rights reserved.
    EOT
    type        = "String"
    description = "Notification email plain text template"
  }

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
