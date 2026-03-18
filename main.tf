################################################################################
# Wrapper calls the official upstream module
# Source: terraform-aws-modules/security-group/aws
# Docs:   https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws
#
# This wrapper adds:
#   - Auto naming:   rohanmatre-{env}-{region}-sg
#   - Auto tagging:  Environment, Owner, GitHubRepo, ManagedBy
#   - Safe defaults: all egress allowed, empty ingress (deny by default)
#   - vpc_id input:  consumed from rohanmatre-vpc-wrapper output
################################################################################

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 4.5.0"

  ##############################################################################
  # General
  ##############################################################################
  create                 = var.create
  create_sg              = var.create_sg
  create_timeout         = var.create_timeout
  delete_timeout         = var.delete_timeout
  description            = var.description
  name                   = local.name
  revoke_rules_on_delete = var.revoke_rules_on_delete
  security_group_id      = var.security_group_id
  tags                   = local.tags
  use_name_prefix        = var.use_name_prefix
  vpc_id                 = var.vpc_id

  ##############################################################################
  # Ingress Rules — Named
  # EXAM: Ingress = inbound traffic TO the resource
  # EXAM: SGs are STATEFUL — response traffic auto-allowed (unlike NACLs)
  # EXAM: Default = deny all inbound (no rules = no access)
  ##############################################################################
  ingress_cidr_blocks                   = var.ingress_cidr_blocks
  ingress_ipv6_cidr_blocks              = var.ingress_ipv6_cidr_blocks
  ingress_prefix_list_ids               = var.ingress_prefix_list_ids
  ingress_rules                         = var.ingress_rules
  ingress_with_cidr_blocks              = var.ingress_with_cidr_blocks
  ingress_with_ipv6_cidr_blocks         = var.ingress_with_ipv6_cidr_blocks
  ingress_with_prefix_list_ids          = var.ingress_with_prefix_list_ids
  ingress_with_self                     = var.ingress_with_self
  ingress_with_source_security_group_id = var.ingress_with_source_security_group_id

  ##############################################################################
  # Egress Rules — Named
  # EXAM: Egress = outbound traffic FROM the resource
  # EXAM: Default = allow all outbound (0.0.0.0/0) — standard practice
  # EXAM: For high security, restrict egress to specific destinations
  ##############################################################################
  egress_cidr_blocks                   = var.egress_cidr_blocks
  egress_ipv6_cidr_blocks              = var.egress_ipv6_cidr_blocks
  egress_prefix_list_ids               = var.egress_prefix_list_ids
  egress_rules                         = var.egress_rules
  egress_with_cidr_blocks              = var.egress_with_cidr_blocks
  egress_with_ipv6_cidr_blocks         = var.egress_with_ipv6_cidr_blocks
  egress_with_prefix_list_ids          = var.egress_with_prefix_list_ids
  egress_with_self                     = var.egress_with_self
  egress_with_source_security_group_id = var.egress_with_source_security_group_id

  ##############################################################################
  # Computed Ingress Rules
  # Use when ingress source is a computed value (e.g. module output)
  # EXAM: You MUST specify number_of_computed_* when using computed values
  ##############################################################################
  computed_ingress_rules                                   = var.computed_ingress_rules
  computed_ingress_with_cidr_blocks                        = var.computed_ingress_cidr_blocks
  computed_ingress_with_ipv6_cidr_blocks                   = var.computed_ingress_with_ipv6_cidr_blocks
  computed_ingress_with_prefix_list_ids                    = var.computed_ingress_with_prefix_list_ids
  computed_ingress_with_self                               = var.computed_ingress_with_self
  computed_ingress_with_source_security_group_id           = var.computed_ingress_with_source_security_group_id
  number_of_computed_ingress_rules                         = var.number_of_computed_ingress_rules
  number_of_computed_ingress_with_cidr_blocks              = var.number_of_computed_ingress_with_cidr_blocks
  number_of_computed_ingress_with_ipv6_cidr_blocks         = var.number_of_computed_ingress_with_ipv6_cidr_blocks
  number_of_computed_ingress_with_prefix_list_ids          = var.number_of_computed_ingress_with_prefix_list_ids
  number_of_computed_ingress_with_self                     = var.number_of_computed_ingress_with_self
  number_of_computed_ingress_with_source_security_group_id = var.number_of_computed_ingress_with_source_security_group_id

  ##############################################################################
  # Computed Egress Rules
  ##############################################################################
  computed_egress_rules                                   = var.computed_egress_rules
  computed_egress_with_cidr_blocks                        = var.computed_egress_with_cidr_blocks
  computed_egress_with_ipv6_cidr_blocks                   = var.computed_egress_with_ipv6_cidr_blocks
  computed_egress_with_prefix_list_ids                    = var.computed_egress_with_prefix_list_ids
  computed_egress_with_self                               = var.computed_egress_with_self
  computed_egress_with_source_security_group_id           = var.computed_egress_with_source_security_group_id
  number_of_computed_egress_rules                         = var.number_of_computed_egress_rules
  number_of_computed_egress_with_cidr_blocks              = var.number_of_computed_egress_with_cidr_blocks
  number_of_computed_egress_with_ipv6_cidr_blocks         = var.number_of_computed_egress_with_ipv6_cidr_blocks
  number_of_computed_egress_with_prefix_list_ids          = var.number_of_computed_egress_with_prefix_list_ids
  number_of_computed_egress_with_self                     = var.number_of_computed_egress_with_self
  number_of_computed_egress_with_source_security_group_id = var.number_of_computed_egress_with_source_security_group_id
}
