resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  name="vpc-dev"
  enable_dns_support = true
  enable_dns_hostnames =true
}


resource "aws_subnet" "public_subnets" {
  for_each = var.vcp_availability_zones
  availability_zone = each.key
  cidr_block =  var.vpc_public_subnets[each.value.name_suffix]
  vpc_id = aws_vpc.myvpc.id
  
}

resource "aws_subnet" "private_subnets" {
  for_each = var.vcp_availability_zones
  availability_zone = each.key
  cidr_block =  var.vpc_private_subnets[each.value.name_suffix]
  vpc_id = aws_vpc.myvpc.id
  
}

resource "aws_subnet" "database_subnets" {
  for_each = var.vcp_availability_zones
  availability_zone = each.key
  cidr_block =  var.vpc_database_subnets[each.value.name_suffix]
  vpc_id = aws_vpc.myvpc.id
  
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "DummyGateway"
  }
}

resource "aws_route_table" "internet_gateway" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "nat_gateway" {
  subnet_id = aws_subnet.nat_gateway.id
  route_table_id = aws_route_table.nat_gateway.id
}