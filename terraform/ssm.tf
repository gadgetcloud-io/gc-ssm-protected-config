# Merge common and environment-specific parameters
# Environment-specific parameters take precedence if there's a conflict
locals {
  all_parameters = merge(var.common_parameters, var.environment_parameters, var.parameters)
}

resource "aws_ssm_parameter" "config" {
  for_each = local.all_parameters

  name        = "/${var.project_name}/${var.environment}/${each.key}"
  description = each.value.description
  type        = each.value.type
  value       = each.value.value
  tier        = each.value.tier

  # Use KMS key for SecureString parameters
  key_id = each.value.type == "SecureString" ? var.kms_key_id : null

  tags = {
    Name        = each.key
    ConfigGroup = split("/", each.key)[0]
  }
}

# KMS key for encrypting sensitive parameters
resource "aws_kms_key" "ssm" {
  description             = "KMS key for ${var.project_name} SSM parameters in ${var.environment}"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name = "${var.project_name}-ssm-${var.environment}"
  }
}

resource "aws_kms_alias" "ssm" {
  name          = "alias/${var.project_name}-ssm-${var.environment}"
  target_key_id = aws_kms_key.ssm.key_id
}

# IAM policy for Lambda functions to read SSM parameters
resource "aws_iam_policy" "lambda_ssm_read" {
  name        = "${var.project_name}-lambda-ssm-read-${var.environment}"
  description = "Allow Lambda functions to read SSM parameters for ${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:${var.aws_region}:*:parameter/${var.project_name}/${var.environment}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = aws_kms_key.ssm.arn
      }
    ]
  })
}
