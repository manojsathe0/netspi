resource "aws_vpc" "netspi_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name        = var.vpc_name,
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_internet_gateway" "netspi_igw" {
  vpc_id = aws_vpc.netspi_vpc.id

  tags = merge(
    {
      Name        = "netspi-igw",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_route_table" "netspi_private_rt" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.netspi_vpc.id

  tags = merge(
    {
      Name        = "PrivateRouteTable",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.netspi_private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.netspi_nat_gw[count.index].id
}

resource "aws_route_table" "netspi_public_rt" {
  vpc_id = aws_vpc.netspi_vpc.id

  tags = merge(
    {
      Name        = "PublicRouteTable",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.netspi_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.netspi_igw.id
}

resource "aws_subnet" "netspi_private_subnet" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.netspi_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name        = "PrivateSubnet",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_subnet" "netspi_public_subnet" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.netspi_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name        = "PublicSubnet",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.netspi_private_subnet[count.index].id
  route_table_id = aws_route_table.netspi_private_rt[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.netspi_public_subnet[count.index].id
  route_table_id = aws_route_table.netspi_public_rt.id
}

# NAT resources

resource "aws_eip" "netspi_nat_eip" {
  count = length(var.public_subnet_cidr_blocks)

  domain   = "vpc"
}

resource "aws_nat_gateway" "netspi_nat_gw" {
  depends_on = [aws_internet_gateway.netspi_igw]

  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.netspi_nat_eip[count.index].id
  subnet_id     = aws_subnet.netspi_public_subnet[count.index].id

  tags = merge(
    {
      Name        = "gwNAT",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}