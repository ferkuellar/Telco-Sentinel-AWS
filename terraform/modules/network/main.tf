resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-vpc-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-igw-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-public-subnet-${count.index + 1}-${replace(var.aws_region, "-", "")}"
    Domain = "net"
    Tier   = "public"
  })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-private-subnet-${count.index + 1}-${replace(var.aws_region, "-", "")}"
    Domain = "net"
    Tier   = "private"
  })
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-nat-eip-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-nat-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-public-rt-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-private-rt-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public_assoc" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_assoc" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public_sg" {
  name        = "${var.name_prefix}-public-sg"
  description = "Baseline public security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-public-sg-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}

resource "aws_security_group" "private_sg" {
  name        = "${var.name_prefix}-private-sg"
  description = "Baseline private security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow HTTPS from public SG"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  ingress {
    description = "Allow internal VPC traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-private-sg-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/aws/vpc/${var.name_prefix}/flowlogs"
  retention_in_days = 14

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-flowlogs-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}

resource "aws_iam_role" "flow_logs_role" {
  name = "${var.name_prefix}-flowlogs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-flowlogs-role-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  name = "${var.name_prefix}-flowlogs-policy"
  role = aws_iam_role.flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-vpc-flowlogs-${replace(var.aws_region, "-", "")}"
    Domain = "net"
  })
}