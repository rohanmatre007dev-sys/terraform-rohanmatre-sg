locals {
  ##############################################################################
  # Naming
  # Pattern: rohanmatre-{environment}-{region}-sg
  # Example: rohanmatre-dev-ap-south-1-sg
  ##############################################################################
  local_name = "rohanmatre-${var.environment}-${var.region}-sg"
  name       = var.name == null ? local.local_name : var.name

  ##############################################################################
  # Environment-Aware Logic
  # EXAM: Prod should have strict SG rules — no wide-open CIDRs
  # EXAM: Dev can be more permissive for developer access
  ##############################################################################
  is_prod = var.environment == "prod"

  ##############################################################################
  # Common Tags — Applied to every resource
  ##############################################################################
  common_tags = {
    Environment = var.environment
    Owner       = "rohanmatre"
    GitHubRepo  = "terraform-rohanmatre-sg"
    ManagedBy   = "terraform"
  }

  tags = merge(local.common_tags, var.tags, { Name = local.name })
}
