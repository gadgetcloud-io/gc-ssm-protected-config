output "parameter_names" {
  description = "List of created SSM parameter names"
  value       = [for param in aws_ssm_parameter.config : param.name]
}

output "parameter_arns" {
  description = "Map of parameter names to ARNs"
  value       = { for k, param in aws_ssm_parameter.config : k => param.arn }
}

output "kms_key_id" {
  description = "KMS key ID for SSM parameters"
  value       = aws_kms_key.ssm.id
}

output "kms_key_arn" {
  description = "KMS key ARN for SSM parameters"
  value       = aws_kms_key.ssm.arn
}

output "lambda_ssm_read_policy_arn" {
  description = "IAM policy ARN for Lambda functions to read SSM parameters"
  value       = aws_iam_policy.lambda_ssm_read.arn
}
