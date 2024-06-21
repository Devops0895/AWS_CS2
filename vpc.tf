resource "aws_vpc" "vpc_bg" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  instance_tenancy     = "default"

  tags = {
    Name = "test_vpc"
  }
}

resource "aws_subnet" "subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc_bg.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_bg.cidr_block, 4, 1)
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "cs-${var.subnet_names}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc_bg.id
  cidr_block              = "10.0.1.0/28"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  depends_on = [aws_internet_gateway.my_igw]
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc_bg.id

  tags = {
    Name = "cs_internet_gateway"
  }
}

resource "aws_eip" "eip_ngw" {
  domain = "VPC"

  tags = {
    name = "elatic-ip-natgateway"
  }

}

resource "aws_nat_gateway" "nat_gateway_private" {

  allocation_id = aws_eip.eip_ngw.id
  subnet_id     = aws_subnet.subnets.id

  tags = {
    Name = "nat-gateway-ec2"
  }

  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my_igw]
}

resource "aws_route_table" "test-private-route" {
  vpc_id = aws_vpc.vpc_bg.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_private.id
  }

  tags = {
    Name = "cs_private_route_table"
  }
}

resource "aws_route_table" "test-public-route" {
  vpc_id = aws_vpc.vpc_bg.id
  tags = {
    Name = "cs_public_route_table"
  }
}

resource "aws_route_table_association" "subnet-assoc" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.test-private-route.id
  subnet_id      = aws_subnet.subnets[count.index].id

}

resource "aws_route_table_association" "publc_subnet-assoc" {
  count          = length(var.availability_zones)
  route_table_id = aws_route_table.test-public-route.id
  subnet_id      = aws_subnet.public_subnet[count.index].id

}
