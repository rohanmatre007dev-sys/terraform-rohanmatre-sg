################################################################################
# Basic Example
# Simplest usage — web server SG allowing HTTP + HTTPS inbound
#
# IMPORTANT: vpc_id comes from your rohanmatre-vpc-wrapper output
#
# What gets created:
#   - 1 Security Group
#   - Ingress: port 80 (HTTP) from anywhere
#   - Ingress: port 443 (HTTPS) from anywhere
#   - Egress:  all traffic to anywhere (default)
#
# Auto-generated name: rohanmatre-dev-ap-south-1-sg
################################################################################

provider "aws" {
  region = "ap-south-1"
}

# Consume VPC from your vpc wrapper
module "vpc" {
  source  = "rohanmatre007dev-sys/vpc/rohanmatre"
  version = "1.0.1"

  environment = "dev"
}

module "sg" {
  source = "../../"

  environment = "dev"
  vpc_id      = module.vpc.vpc_id # ← output from vpc wrapper

  # Named rules — predefined port combinations
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # Egress — allow all outbound (default)
  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
