locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

resource "aws_eip" "nat" {
  count  = 1
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-nat-eip-${count.index + 1}"
  })
}

resource "aws_subnet" "public" {
  count = 3

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-public-${count.index + 1}"
    Tier = "public"
  })
}

resource "aws_subnet" "app" {
  count = 3

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 5)
  map_public_ip_on_launch = false
  availability_zone       = element(var.azs, count.index)

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-app-${count.index + 1}"
    Tier = "app"
  })
}

resource "aws_subnet" "db" {
  count = 3

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  map_public_ip_on_launch = false
  availability_zone       = element(var.azs, count.index)

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-db-${count.index + 1}"
    Tier = "db"
  })
}

resource "aws_nat_gateway" "nat" {
  count = 1

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-nat-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count = 3

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-app-rt"
  })
}

resource "aws_route" "app_nat" {
  route_table_id         = aws_route_table.app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "app" {
  count = 3

  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table" "private_no_nat" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-db-rt"
  })
}

resource "aws_route_table_association" "private_no_nat" {
  count = 3

  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.private_no_nat.id
}