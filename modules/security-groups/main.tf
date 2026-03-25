locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  for_each = toset(var.allowed_ingress_cidrs)

  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  description = "Allow HTTP from allowed CIDRs"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  for_each = toset(var.allowed_ingress_cidrs)

  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = each.value
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  description = "Allow HTTPS from allowed CIDRs"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_outbound" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound traffic"
}

resource "aws_security_group" "ecs" {
  name        = "${local.name_prefix}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"

  description = "Allow application traffic from ALB security group"
}

resource "aws_vpc_security_group_egress_rule" "ecs_all_outbound" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound traffic"
}

resource "aws_security_group" "db" {
  name        = "${local.name_prefix}-db-sg"
  description = "Security group for database"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-db-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "db_from_ecs" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.ecs.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"

  description = "Allow database traffic from ECS security group"
}

resource "aws_vpc_security_group_egress_rule" "db_all_outbound" {
  security_group_id = aws_security_group.db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound traffic"
}

resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-bastion-sg"
  description = "Security group for Bastion host"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-bastion-sg"
  })
}


resource "aws_vpc_security_group_egress_rule" "bastion_all_outbound" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "db_from_bastion" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.bastion.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"

  description = "Allow DB access from Bastion"
}
