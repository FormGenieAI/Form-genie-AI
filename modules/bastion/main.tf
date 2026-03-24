data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_iam_role" "bastion_ssm_role" {
  name = "${var.project_name}-${var.environment}-bastion-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-bastion-ssm-role"
  })
}

resource "aws_iam_role_policy_attachment" "bastion_ssm_core" {
  role       = aws_iam_role.bastion_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.project_name}-${var.environment}-bastion-instance-profile"
  role = aws_iam_role.bastion_ssm_role.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-bastion-instance-profile"
  })
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  associate_public_ip_address = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-bastion"
  })
}

resource "aws_eip" "this" {
  domain   = "vpc"
  instance = aws_instance.this.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-bastion-eip"
  })

  depends_on = [aws_instance.this]
}