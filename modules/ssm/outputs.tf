output "db_host_parameter_name" {
  value = aws_ssm_parameter.db_host.name
}

output "db_user_parameter_name" {
  value = aws_ssm_parameter.db_user.name
}

output "db_password_parameter_name" {
  value = aws_ssm_parameter.db_password.name
}

output "db_name_parameter_name" {
  value = aws_ssm_parameter.db_name.name
}

output "db_host_arn" {
  value = aws_ssm_parameter.db_host.arn
}

output "db_user_arn" {
  value = aws_ssm_parameter.db_user.arn
}

output "db_password_arn" {
  value = aws_ssm_parameter.db_password.arn
}

output "db_name_arn" {
  value = aws_ssm_parameter.db_name.arn
}