################################################################################
# Advanced Example
# Multiple security groups with cross-SG source references
#
# Pattern: ALB SG → EC2 SG → RDS SG (layered security)
#
# EXAM: This is the industry standard pattern:
#   - ALB SG:  allows 80/443 from internet
#   - App SG:  allows 8080 only from ALB SG (not from internet directly)
#   - DB SG:   allows 3306 only from App SG (completely isolated)
################################################################################

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source  = "rohanmatre007dev-sys/vpc/rohanmatre"
  version = "1.0.1"

  environment      = "prod"
  cidr             = "10.10.0.0/16"
  public_subnets   = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets  = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
}

# ALB Security Group — internet facing
module "alb_sg" {
  source = "../../"

  name        = "rohanmatre-prod-alb-sg"
  environment = "prod"
  vpc_id      = module.vpc.vpc_id

  description = "ALB security group — allows HTTP and HTTPS from internet"

  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = { Role = "alb" }
}

# App Security Group — only from ALB SG
module "app_sg" {
  source = "../../"

  name        = "rohanmatre-prod-app-sg"
  environment = "prod"
  vpc_id      = module.vpc.vpc_id

  description = "App security group — allows traffic only from ALB SG"

  # Custom rule referencing ALB SG directly (not CIDR)
  ingress_with_source_security_group_id = [
    {
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      description              = "App port from ALB only"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = { Role = "app" }
}

# DB Security Group — only from App SG
module "db_sg" {
  source = "../../"

  name        = "rohanmatre-prod-db-sg"
  environment = "prod"
  vpc_id      = module.vpc.vpc_id

  description = "DB security group — allows MySQL only from App SG"

  # Only App SG can reach the database
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      description              = "MySQL from app servers only"
      source_security_group_id = module.app_sg.security_group_id
    }
  ]

  # DB servers should not initiate outbound (strict)
  egress_rules       = []
  egress_cidr_blocks = []

  tags = { Role = "database" }
}
