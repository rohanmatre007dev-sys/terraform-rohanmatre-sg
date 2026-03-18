################################################################################
# Security Group Outputs
# These are consumed by: EC2, RDS, Lambda, ALB, ECS wrappers
################################################################################

output "security_group_arn" {
  description = "ARN of the security group"
  value       = module.sg.security_group_arn
}

output "security_group_description" {
  description = "Description of the security group"
  value       = module.sg.security_group_description
}

output "security_group_id" {
  description = "ID of the security group — consumed by EC2, RDS, Lambda, ALB wrappers"
  value       = module.sg.security_group_id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = module.sg.security_group_name
}

output "security_group_owner_id" {
  description = "Owner ID (AWS Account ID) of the security group"
  value       = module.sg.security_group_owner_id
}

output "security_group_vpc_id" {
  description = "VPC ID where the security group was created"
  value       = module.sg.security_group_vpc_id
}
