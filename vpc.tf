
provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "working" {}


locals {
  cidr_block = "192.168.0.0/25"
  az_count   = length(data.aws_availability_zones.working.names)

  bastion_ports = [{
    description = "SSH",
    port        = 22,
    cidr_blocks = ["0.0.0.0/0"],
  }]

  frontend_ports = [{
    description = "HTTP",
    port        = 80,
    cidr_blocks = ["0.0.0.0/0"],
    }, {
    description = "SSH",
    port        = 22,
    cidr_blocks = ["192.168.0.0/25"],
    }, {
    description = "HTTPS",
    port        = 443,
    cidr_blocks = ["0.0.0.0/0"],
  }]

  backend_ports = [{
    description = "SSH",
    port        = 22,
    cidr_blocks = ["192.168.0.0/25"],
    }, {
    description = "App",
    port        = 8080,
    cidr_blocks = ["0.0.0.0/0"],
  }]
}

resource "aws_vpc" "project_vpc" {
  cidr_block           = local.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "Project VPC"
  }
}



resource "aws_subnet" "subnet_public" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = cidrsubnet(local.cidr_block, local.az_count, count.index)
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.working.names[count.index]
  tags = {
    Name = "SubnetPublic ${data.aws_availability_zones.working.names[count.index]}"
  }
}

resource "aws_subnet" "subnet_private" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = cidrsubnet(local.cidr_block, local.az_count, count.index + 3)
  map_public_ip_on_launch = "false"
  availability_zone       = data.aws_availability_zones.working.names[count.index]
  tags = {
    Name = "SubnetPrivate ${data.aws_availability_zones.working.names[count.index]}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group_private" {
  name       = "db_subnet"
  subnet_ids = aws_subnet.subnet_private.*.id

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_internet_gateway" "project_gw" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
    Name = "Project Gateway"
  }
}

resource "aws_route_table" "project_rt_gw" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_gw.id
  }
  tags = {
    Name = "Project Gateway Route Table"
  }
}


resource "aws_route_table_association" "project_rt_asso" {
  count          = local.az_count
  subnet_id      = element(aws_subnet.subnet_public[*].id, count.index)
  route_table_id = aws_route_table.project_rt_gw.id
}

resource "aws_eip" "project_eip" {
  depends_on = [aws_internet_gateway.project_gw]
}

resource "aws_nat_gateway" "project_nat" {
  allocation_id = aws_eip.project_eip.id
  subnet_id     = element(aws_subnet.subnet_public.*.id, 0)

  tags = {
    Name = "Project NAT Gateway"

  }
}

resource "aws_route_table" "project_rt_nat" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.project_nat.id
  }
  tags = {
    Name = "Project NAT Route Table"
  }
}


resource "aws_route_table_association" "project_rt_nat_asso" {
  count          = local.az_count
  subnet_id      = element(aws_subnet.subnet_private[*].id, count.index)
  route_table_id = aws_route_table.project_rt_nat.id
}

resource "aws_security_group" "bastion_cg" {
  name        = "Bastion Security Group"
  description = "Bastion Security Group"
  vpc_id      = aws_vpc.project_vpc.id

  dynamic "ingress" {
    for_each = local.bastion_ports
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion Security Group"
  }
}

resource "aws_security_group" "frontend_cg" {
  name        = "Frontend Security Group"
  description = "Frontend Security Group"
  vpc_id      = aws_vpc.project_vpc.id

  dynamic "ingress" {
    for_each = local.frontend_ports
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Frontend Security Group"
  }
}

resource "aws_security_group" "backend_cg" {
  name        = "Backend Security Group"
  description = "Backend Security Group"
  vpc_id      = aws_vpc.project_vpc.id

  dynamic "ingress" {
    for_each = local.backend_ports
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Backend Security Group"
  }
}

resource "aws_security_group" "project_cg_rds" {
  name        = "Project Security Group RDS"
  description = "Project Security Group RDS"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/25"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Project Security Group RDS"
  }
}









