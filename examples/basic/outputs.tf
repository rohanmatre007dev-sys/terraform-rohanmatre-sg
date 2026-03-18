output "security_group_id" {
  description = "ID of the security group"
  value       = module.sg.security_group_id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = module.sg.security_group_name
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = module.sg.security_group_arn
}
