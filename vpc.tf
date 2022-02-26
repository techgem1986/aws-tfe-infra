### Network


/*A VPC with a size /16 IPv4 CIDR block (example: 10.0.0.0/16).
This provides 65,536 private IPv4 addresses.*/

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "vpc"
    Environment = "Dev"
  }
}

/*A public subnet with a size /24 IPv4 CIDR block (example: 10.0.0.0/24).
This provides 256 private IPv4 addresses.
A public subnet is a subnet that's associated with a route table that has a route to an internet gateway.*/

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Public Subnet"
    Environment = "Dev"
  }
}
/*A private subnet with a size /24 IPv4 CIDR block (example: 10.0.1.0/24).
 This provides 256 private IPv4 addresses.*/

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Private Subnet"
    Environment = "Dev"
  }
}

/*
An internet gateway.
This connects the VPC to the internet and to other AWS services.*/

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Internet Gateway"
    Environment = "Dev"
  }
}

/* A NAT gateway with its own Elastic IPv4 address.
Instances in the private subnet can send requests to the internet through the NAT gateway over IPv4 (for example, for software updates).*/

resource "aws_eip" "elastic-ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id = aws_subnet.private-subnet.id
  tags = {
    Name = "NAT Gateway"
    Environment = "Dev"
  }
  depends_on = [aws_internet_gateway.internet-gateway]
}

/* A custom route table associated with the public subnet.
This route table contains an entry that enables instances in the subnet to communicate with other instances in the VPC over IPv4,
and an entry that enables instances in the subnet to communicate directly with the internet over IPv4.*/

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "Public Route Table"
    Environment = "Dev"
  }
}

/* The main route table associated with the private subnet.
The route table contains an entry that enables instances in the subnet to communicate with other instances in the VPC over IPv4,
and an entry that enables instances in the subnet to communicate with the internet through the NAT gateway over IPv4.*/

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "Public Route Table"
    Environment = "Dev"
  }
}

# route associations public
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-subnet-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-route-table.id
}
