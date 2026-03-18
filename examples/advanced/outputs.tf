output "alb_sg_id" { value = module.alb_sg.security_group_id }
output "app_sg_id" { value = module.app_sg.security_group_id }
output "db_sg_id" { value = module.db_sg.security_group_id }

output "alb_sg_arn" { value = module.alb_sg.security_group_arn }
output "app_sg_arn" { value = module.app_sg.security_group_arn }
output "db_sg_arn" { value = module.db_sg.security_group_arn }
