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

  # Email Template: Email Verification
  "email/email-verification/subject" = {
    value       = "Verify Your GadgetCloud Email"
    type        = "String"
    description = "Email verification subject"
  }
  "email/email-verification/html" = {
    value       = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="background-color: #f8f9fa; padding: 20px; border-radius: 5px;">
          <h1 style="color: #2c3e50; margin-bottom: 20px;">Welcome to GadgetCloud!</h1>
          <p>Please verify your email address to complete your registration.</p>
          <div style="text-align: center; margin: 30px 0;">
            <a href="{verification_link}" style="background-color: #27ae60; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;">Verify Email</a>
          </div>
          <div style="background-color: #e8f5e9; padding: 15px; border-left: 4px solid #27ae60; margin: 20px 0;">
            <p style="margin: 0;"><strong>Security Information:</strong></p>
            <p style="margin: 5px 0;">This verification link will expire in 24 hours.</p>
            <p style="margin: 5px 0;">If you did not create an account, please ignore this email.</p>
          </div>
          <p>Or copy and paste this URL into your browser:</p>
          <p style="word-break: break-all; background-color: #f0f0f0; padding: 10px; border-radius: 3px;">{verification_link}</p>
          <p style="margin-top: 30px;">Best regards,<br>The GadgetCloud Team</p>
        </div>
        <div style="text-align: center; margin-top: 20px; color: #7f8c8d; font-size: 12px;">
          <p>GadgetCloud Authentication Service</p>
          <p>This is an automated email, please do not reply.</p>
          <p>&copy; 2025 GadgetCloud. All rights reserved.</p>
        </div>
      </body>
      </html>
    EOT
    type        = "String"
    description = "Email verification HTML template"
  }
  "email/email-verification/text" = {
    value       = <<-EOT
      Welcome to GadgetCloud!

      Please verify your email address to complete your registration.

      Verification Link:
      {verification_link}

      Security Information:
      - This verification link will expire in 24 hours
      - If you did not create an account, please ignore this email

      Best regards,
      The GadgetCloud Team

      ---
      GadgetCloud Authentication Service
      This is an automated email, please do not reply.

      © 2025 GadgetCloud. All rights reserved.
    EOT
    type        = "String"
    description = "Email verification plain text template"
  }

  # Email Template: Account Deletion
  "email/account-deletion/subject" = {
    value       = "GadgetCloud Account Deletion Scheduled"
    type        = "String"
    description = "Account deletion confirmation subject"
  }
  "email/account-deletion/html" = {
    value       = <<-EOT
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;">
        <div style="background-color: #f8f9fa; padding: 20px; border-radius: 5px;">
          <h1 style="color: #e74c3c; margin-bottom: 20px;">Account Deletion Scheduled</h1>
          <p>We have received your request to delete your GadgetCloud account ({email}).</p>
          <div style="background-color: #fff3cd; padding: 15px; border-left: 4px solid #ffc107; margin: 20px 0;">
            <p style="margin: 0;"><strong>Important:</strong></p>
            <p style="margin: 5px 0;">Your account has been marked for deletion and will be permanently removed on <strong>{deletion_date}</strong>.</p>
            <p style="margin: 5px 0;">You have a <strong>30-day grace period</strong> to change your mind.</p>
          </div>
          <p><strong>To reactivate your account:</strong></p>
          <p>Simply log in to your account before {deletion_date}, and your account will be automatically restored.</p>
          {reason_section}
          <div style="background-color: #ffebee; padding: 15px; border-left: 4px solid #e74c3c; margin: 20px 0;">
            <p style="margin: 0;"><strong>After {deletion_date}:</strong></p>
            <p style="margin: 5px 0;">• All your data will be permanently deleted</p>
            <p style="margin: 5px 0;">• This action cannot be undone</p>
            <p style="margin: 5px 0;">• You will need to create a new account to use GadgetCloud</p>
          </div>
          <p>If you did not request this deletion, please contact our support team immediately at {support_email}.</p>
          <p style="margin-top: 30px;">Best regards,<br>The GadgetCloud Team</p>
        </div>
        <div style="text-align: center; margin-top: 20px; color: #7f8c8d; font-size: 12px;">
          <p>&copy; 2025 GadgetCloud. All rights reserved.</p>
        </div>
      </body>
      </html>
    EOT
    type        = "String"
    description = "Account deletion confirmation HTML template"
  }
  "email/account-deletion/text" = {
    value       = <<-EOT
      Account Deletion Scheduled

      We have received your request to delete your GadgetCloud account ({email}).

      IMPORTANT:
      - Your account has been marked for deletion and will be permanently removed on {deletion_date}
      - You have a 30-day grace period to change your mind

      To reactivate your account:
      Simply log in to your account before {deletion_date}, and your account will be automatically restored.

      {reason_text}

      After {deletion_date}:
      • All your data will be permanently deleted
      • This action cannot be undone
      • You will need to create a new account to use GadgetCloud

      If you did not request this deletion, please contact our support team immediately at {support_email}.

      Best regards,
      The GadgetCloud Team

      © 2025 GadgetCloud. All rights reserved.
    EOT
    type        = "String"
    description = "Account deletion confirmation plain text template"
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
