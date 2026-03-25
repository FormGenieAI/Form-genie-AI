output "bastion_public_ip" {
  value = aws_eip.this.public_ip
}

output "bastion_elastic_ip" {
  value = aws_eip.this.public_ip
}

output "bastion_private_ip" {
  value = aws_instance.this.private_ip
}

output "bastion_instance_id" {
  value = aws_instance.this.id
}