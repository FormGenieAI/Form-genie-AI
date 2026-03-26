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

  tags = var.tags
}

module "iam" {
  source = "../modules/iam_roles"

  project_name = var.project_name
  environment  = var.environment

  ssm_parameter_arns = [
    module.ssm_parameters.db_host_arn,
    module.ssm_parameters.db_user_arn,
    module.ssm_parameters.db_password_arn,
    module.ssm_parameters.db_name_arn
  ]

  kms_key_arns = []

  common_tags = var.tags
}

module "ecs_cluster" {
  source = "../modules/ecs-cluster"

  name        = "${var.project_name}-${var.environment}-ecs-cluster"
  environment = var.environment

  cluster_settings = [
    {
      name  = "containerInsights"
      value = "enabled"
    }
  ]

  execute_command_logging                       = "OVERRIDE"
  execute_command_log_group_name                = aws_cloudwatch_log_group.ecs_exec.name
  execute_command_cloudwatch_encryption_enabled = true

  enable_capacity_providers = true

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
      weight            = 1
    }
  ]

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs_exec" {
  name              = "/aws/ecs/${var.project_name}-${var.environment}/exec"
  retention_in_days = 7

  tags = var.tags
}


module "ecr" {
  source = "../modules/ecr"

  repository_name       = var.ecr_repository_name
  image_retention_count = var.ecr_image_retention_count
  common_tags           = var.tags
}

module "ssm_parameters" {
  source = "../modules/ssm"

  prefix      = var.ssm_prefix
  db_host     = var.ssm_db_host
  db_user     = var.ssm_db_user
  db_password = var.ssm_db_password
  db_name     = var.ssm_db_name

  tags = var.tags
}