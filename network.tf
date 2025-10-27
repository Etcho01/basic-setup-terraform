resource "aws_internet_gateway" "custom_igw1" {
  vpc_id = aws_vpc.custom_vpc1.id
  tags = {
    Name = "custom_igw1"
  }
}

resource "aws_eip" "custom_nat_eip1" {
  domain = "vpc"
  tags = {
    Name = "custom_nat_eip1"
  }
}

resource "aws_nat_gateway" "custom_nat_gw1" {
  allocation_id = aws_eip.custom_nat_eip1.id
  subnet_id     = aws_subnet.custom_public_subnet1.id
  tags = {
    Name = "custom_nat_gw1"
  }
  depends_on = [aws_internet_gateway.custom_igw1]
}

resource "aws_route_table" "custom_public_rt" {
  vpc_id = aws_vpc.custom_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw1.id
  }

  tags = {
    Name = "custom_public_rt"
  }
}

resource "aws_route_table" "custom_private_rt" {
  vpc_id = aws_vpc.custom_vpc1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.custom_nat_gw1.id
  }

  tags = {
    Name = "custom_private_rt"
  }
}

resource "aws_vpc" "custom_vpc1" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "custom_vpc1"
  }
}

resource "aws_subnet" "custom_public_subnet1" {
  vpc_id                  = aws_vpc.custom_vpc1.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"
  tags = {
    Name = "custom_pub_subnet1"
  }
}

resource "aws_route_table_association" "custom_pub_assoc1" {
  subnet_id      = aws_subnet.custom_public_subnet1.id
  route_table_id = aws_route_table.custom_public_rt.id
}

resource "aws_subnet" "custom_private_subnet1" {
  vpc_id            = aws_vpc.custom_vpc1.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "custom_priv_subnet1"
  }
}

resource "aws_route_table_association" "custom_priv_assoc1" {
  subnet_id      = aws_subnet.custom_private_subnet1.id
  route_table_id = aws_route_table.custom_private_rt.id
}
