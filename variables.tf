################################################################################
# General
################################################################################

variable "create" {
  description = "Controls whether security group and all rules will be created"
  type        = bool
  default     = true
}

variable "region" {
  description = "AWS region where security group will be created"
  type        = string
  # default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be one of: dev, stage, prod."
  }
}

variable "name" {
  description = "Name of the security group. Auto-generated if null."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags merged with common tags"
  type        = map(string)
  default     = {}
}

################################################################################
# Security Group Core
# EXAM: Security Groups are STATEFUL — return traffic is automatically allowed
# EXAM: SGs apply at the ENI (instance) level, not subnet level
# EXAM: SGs can reference other SGs as source — no need to hardcode IPs
################################################################################

variable "description" {
  description = "Description of the security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group. Comes from rohanmatre-vpc-wrapper output."
  type        = string
  default     = null
}

variable "create_sg" {
  description = "Whether to create security group resource itself"
  type        = bool
  default     = true
}

variable "security_group_id" {
  description = "ID of existing security group to manage rules for (when create_sg=false)"
  type        = string
  default     = null
}

variable "use_name_prefix" {
  description = "Use name_prefix instead of fixed name (allows in-place SG name updates)"
  type        = bool
  default     = true
}

variable "revoke_rules_on_delete" {
  description = "Revoke all SG rules before deleting. Required for EMR clusters."
  type        = bool
  default     = false
}

variable "create_timeout" {
  description = "Timeout for security group creation"
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Timeout for security group deletion"
  type        = string
  default     = "15m"
}

################################################################################
# Ingress Rules — Named (predefined port combinations)
# EXAM: Ingress = inbound traffic TO the resource
# Examples: ssh-tcp (22), http-80-tcp (80), https-443-tcp (443), mysql-tcp (3306)
################################################################################

variable "ingress_rules" {
  description = "List of named ingress rules to create (e.g. ssh-tcp, http-80-tcp, https-443-tcp)"
  type        = list(string)
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges for all ingress rules"
  type        = list(string)
  default     = []
}

variable "ingress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges for all ingress rules"
  type        = list(string)
  default     = []
}

variable "ingress_prefix_list_ids" {
  description = "List of prefix list IDs for VPC endpoint ingress access"
  type        = list(string)
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of custom ingress rules with cidr_blocks"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_ipv6_cidr_blocks" {
  description = "List of custom ingress rules with ipv6_cidr_blocks"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_prefix_list_ids" {
  description = "List of custom ingress rules with prefix_list_ids"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_self" {
  description = "List of ingress rules allowing traffic from same SG"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules with source_security_group_id"
  type        = list(map(string))
  default     = []
}

################################################################################
# Egress Rules — Named (predefined port combinations)
# EXAM: Egress = outbound traffic FROM the resource
# EXAM: Default SG allows all outbound — this is common practice
################################################################################

variable "egress_rules" {
  description = "List of named egress rules to create (default: all-all)"
  type        = list(string)
  default     = ["all-all"]
}

variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges for all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges for all egress rules"
  type        = list(string)
  default     = ["::/0"]
}

variable "egress_prefix_list_ids" {
  description = "List of prefix list IDs for VPC endpoint egress access"
  type        = list(string)
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "List of custom egress rules with cidr_blocks"
  type        = list(map(string))
  default     = []
}

variable "egress_with_ipv6_cidr_blocks" {
  description = "List of custom egress rules with ipv6_cidr_blocks"
  type        = list(map(string))
  default     = []
}

variable "egress_with_prefix_list_ids" {
  description = "List of custom egress rules with prefix_list_ids"
  type        = list(map(string))
  default     = []
}

variable "egress_with_self" {
  description = "List of egress rules allowing traffic to same SG"
  type        = list(map(string))
  default     = []
}

variable "egress_with_source_security_group_id" {
  description = "List of egress rules with source_security_group_id"
  type        = list(map(string))
  default     = []
}

################################################################################
# Computed Ingress Rules
# Use these when source value is computed (e.g. from another module output)
# EXAM: Terraform requires explicit count for computed values in older versions
################################################################################

variable "computed_ingress_rules" {
  description = "List of computed ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "computed_ingress_cidr_blocks" {
  description = "List of computed ingress rules with cidr_blocks"
  type        = list(map(string))
  default     = []
}

variable "computed_ingress_with_ipv6_cidr_blocks" {
  description = "List of computed ingress rules with ipv6_cidr_blocks"
  type        = list(map(string))
  default     = []
}

variable "computed_ingress_with_prefix_list_ids" {
  description = "List of computed ingress rules with prefix_list_ids"
  type        = list(map(string))
  default     = []
}

variable "computed_ingress_with_self" {
  description = "List of computed ingress rules where self is defined"
  type        = list(map(string))
  default     = []
}

variable "computed_ingress_with_source_security_group_id" {
  description = "List of computed ingress rules with source_security_group_id"
  type        = list(map(string))
  default     = []
}

variable "number_of_computed_ingress_rules" {
  description = "Number of computed ingress rules (required when using computed values)"
  type        = number
  default     = 0
}

variable "number_of_computed_ingress_with_cidr_blocks" {
  description = "Number of computed ingress rules with cidr_blocks"
  type        = number
  default     = 0
}

variable "number_of_computed_ingress_with_ipv6_cidr_blocks" {
  description = "Number of computed ingress rules with ipv6_cidr_blocks"
  type        = number
  default     = 0
}

variable "number_of_computed_ingress_with_prefix_list_ids" {
  description = "Number of computed ingress rules with prefix_list_ids"
  type        = number
  default     = 0
}

variable "number_of_computed_ingress_with_self" {
  description = "Number of computed ingress rules where self is defined"
  type        = number
  default     = 0
}

variable "number_of_computed_ingress_with_source_security_group_id" {
  description = "Number of computed ingress rules with source_security_group_id"
  type        = number
  default     = 0
}

################################################################################
# Computed Egress Rules
################################################################################

variable "computed_egress_rules" {
  description = "List of computed egress rules to create by name"
  type        = list(string)
  default     = []
}

variable "computed_egress_with_cidr_blocks" {
  description = "List of computed egress rules with cidr_blocks"
  type        = list(map(string))
  default     = []
}

variable "computed_egress_with_ipv6_cidr_blocks" {
  description = "List of computed egress rules with ipv6_cidr_blocks"
  type        = list(map(string))
  default     = []
}

variable "computed_egress_with_prefix_list_ids" {
  description = "List of computed egress rules with prefix_list_ids"
  type        = list(map(string))
  default     = []
}

variable "computed_egress_with_self" {
  description = "List of computed egress rules where self is defined"
  type        = list(map(string))
  default     = []
}

variable "computed_egress_with_source_security_group_id" {
  description = "List of computed egress rules with source_security_group_id"
  type        = list(map(string))
  default     = []
}

variable "number_of_computed_egress_rules" {
  description = "Number of computed egress rules"
  type        = number
  default     = 0
}

variable "number_of_computed_egress_with_cidr_blocks" {
  description = "Number of computed egress rules with cidr_blocks"
  type        = number
  default     = 0
}

variable "number_of_computed_egress_with_ipv6_cidr_blocks" {
  description = "Number of computed egress rules with ipv6_cidr_blocks"
  type        = number
  default     = 0
}

variable "number_of_computed_egress_with_prefix_list_ids" {
  description = "Number of computed egress rules with prefix_list_ids"
  type        = number
  default     = 0
}

variable "number_of_computed_egress_with_self" {
  description = "Number of computed egress rules where self is defined"
  type        = number
  default     = 0
}

variable "number_of_computed_egress_with_source_security_group_id" {
  description = "Number of computed egress rules with source_security_group_id"
  type        = number
  default     = 0
}
