# terraform-rohanmatre-sg

Terraform wrapper module for AWS Security Groups — built on top of [terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws).

This wrapper adds:
- **Auto naming** → `rohanmatre-{environment}-{region}-sg`
- **Auto tagging** → `Environment`, `Owner`, `GitHubRepo`, `ManagedBy`
- **Safe defaults** → all egress allowed, empty ingress (deny all inbound by default)
- **vpc_id input** → consumed directly from `rohanmatre-vpc-wrapper` output

---

## Dependency

This wrapper consumes output from `rohanmatre-vpc-wrapper`:

```hcl
vpc_id = module.vpc.vpc_id
```

---

## Usage

### Basic (web server)

```hcl
module "sg" {
  source  = "rohanmatre007dev-sys/sg/rohanmatre"
  version = "1.0.0"

  environment = "dev"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
}
```

### Advanced (layered SGs — ALB → App → DB)

```hcl
# App SG — only accepts traffic from ALB SG
module "app_sg" {
  source  = "rohanmatre007dev-sys/sg/rohanmatre"
  version = "1.0.0"

  environment = "prod"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
}
```

---

## Common Named Rules

| Rule Name | Port | Protocol | Use Case |
|---|---|---|---|
| `ssh-tcp` | 22 | TCP | SSH access |
| `http-80-tcp` | 80 | TCP | HTTP web traffic |
| `https-443-tcp` | 443 | TCP | HTTPS web traffic |
| `mysql-tcp` | 3306 | TCP | MySQL / Aurora |
| `postgresql-tcp` | 5432 | TCP | PostgreSQL |
| `redis-tcp` | 6379 | TCP | Redis / ElastiCache |
| `all-all` | all | all | Allow all traffic |

Full list: [upstream module rules](https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf)

---

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
| `create` | Controls whether resources will be created | `bool` | `true` |
| `region` | AWS region | `string` | `"ap-south-1"` |
| `environment` | Environment: dev, stage, prod | `string` | `"dev"` |
| `name` | SG name. Auto-generated if null | `string` | `null` |
| `description` | SG description | `string` | `"Security Group managed by Terraform"` |
| `vpc_id` | VPC ID from rohanmatre-vpc-wrapper | `string` | `null` |
| `ingress_rules` | Named ingress rules (e.g. ssh-tcp) | `list(string)` | `[]` |
| `ingress_cidr_blocks` | IPv4 CIDRs for ingress rules | `list(string)` | `[]` |
| `ingress_with_source_security_group_id` | Ingress from another SG | `list(map(string))` | `[]` |
| `egress_rules` | Named egress rules | `list(string)` | `["all-all"]` |
| `egress_cidr_blocks` | IPv4 CIDRs for egress rules | `list(string)` | `["0.0.0.0/0"]` |
| `tags` | Additional tags | `map(string)` | `{}` |

Full list: [variables.tf](variables.tf)

---

## Outputs

| Name | Description | Consumed By |
|---|---|---|
| `security_group_id` | ID of the security group | EC2, RDS, Lambda, ALB wrappers |
| `security_group_arn` | ARN of the security group | IAM policies |
| `security_group_name` | Name of the security group | Reference |
| `security_group_description` | Description of the security group | Reference |
| `security_group_owner_id` | AWS Account ID of the owner | Reference |
| `security_group_vpc_id` | VPC ID where SG was created | Reference |

---

## Notes

- Auto-generates name as `rohanmatre-{environment}-{region}-sg`
- Merges tags with `{Environment, Owner=rohanmatre, GitHubRepo, ManagedBy=terraform}`
- Upstream module: [terraform-aws-modules/security-group/aws >= 4.5.0](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws)
- Default region: `ap-south-1`

---

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.5.7 |
| aws | >= 3.29 |
