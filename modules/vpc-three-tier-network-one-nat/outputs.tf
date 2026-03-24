output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "app_subnets" {
  description = "IDs of the application subnets"
  value       = aws_subnet.app[*].id
}

output "db_subnets" {
  description = "IDs of the database subnets"
  value       = aws_subnet.db[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.nat[*].id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "app_route_table_id" {
  description = "ID of the application route table"
  value       = aws_route_table.app.id
}

output "db_route_table_id" {
  description = "ID of the database route table"
  value       = aws_route_table.private_no_nat.id
}