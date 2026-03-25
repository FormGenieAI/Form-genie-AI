module "vpc" {
  source = "../modules/vpc-three-tier-network-one-nat"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  azs          = var.azs
  common_tags  = var.tags
}

module "security_groups" {
  source = "../modules/security-groups"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  app_port              = var.app_port
  db_port               = var.db_port
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
  common_tags           = var.tags
}

module "bastion" {
  source = "../modules/bastion"

  project_name     = var.project_name
  environment      = var.environment
  public_subnet_id = module.vpc.public_subnets[0]
  bastion_sg_id    = module.security_groups.bastion_security_group_id
  key_name         = var.bastion_key_name
  common_tags      = var.tags
}

module "security" {
  source = "../modules/security"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  cloudtrail_s3_bucket_name = "${var.project_name}-${var.environment}-cloudtrail-logs"
  config_s3_bucket_name     = "${var.project_name}-${var.environment}-config-logs"

  cloudtrail_log_group_retention_in_days = 30

  enable_multi_region_trail     = true
  enable_log_file_validation    = true
  include_global_service_events = true

  enable_guardduty   = false
  enable_inspector   = false
  enable_securityhub = false

  enable_config               = true
  enable_config_managed_rules = true

  enable_notifications = true
  notification_emails  = ["support@formgenieai.com"]

  tags = var.tags
}