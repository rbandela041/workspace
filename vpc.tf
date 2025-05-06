resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = join("-", [local.vpc_name, local.env])
    Env  = local.env
  }
}

resource "aws_internet_gateway" "vpc1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = join("-", [local.vpc_name, local.env, "igw"])
    Env  = local.env
  }
}


resource "aws_subnet" "public-subnets" {
  count             = length(var.public_subnet_cidrs)  ### length means how many subnets we have in the list it will create those many subnets
  cidr_block        = element(var.public_subnet_cidrs, count.index) ### element means it will take the first element from the list and assign it to the subnet
  availability_zone = element(var.azs, count.index) #element here means it will take the first element from the azs list and assign it to the subnet
  vpc_id            = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.vpc_name}-public-subnet-${count.index + 1}"
    Env  = local.env
  }
}

resource "aws_subnet" "private-subnets" {
  count             = length(var.private_subnet_cidrs)  ### length means how many subnets we have in the list it will create those many subnets
  cidr_block        = element(var.private_subnet_cidrs, count.index) ### element means it will take the first element from the list and assign it to the subnet
  availability_zone = element(var.azs, count.index) #element here means it will take the first element from the azs list and assign it to the subnet
  vpc_id            = aws_vpc.vpc1.id
  tags = {
    Name = "${local.vpc_name}-private-subnet-${count.index + 1}" #${count.index + 1} means it will take the first element from the list and assign it to the subnet and add 1 to it
    Env  = local.env
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1.id
    }
    tags = {
      Name = "${local.vpc_name}-public-rt"
      Env  = local.env
    }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "${local.vpc_name}-private-rt"
    Env  = local.env
  }
}

###associating the public subnets with the public route table
resource "aws_route_table_association" "public-rt-association" {
  count             = length(var.public_subnet_cidrs)  ### it will check how many public subnets we have and associate them with the public route table
  subnet_id         = element(aws_subnet.public-subnets[*].id, count.index) ### it will take the first element from the public subnets list and associate it with the public route table
  route_table_id    = aws_route_table.public-rt.id 
}

####associating the private subnets with the private route table
resource "aws_route_table_association" "private-rt-association" {
  count             = length(var.private_subnet_cidrs)  ### it will check how many private subnets we have and associate them with the private route table
  subnet_id         = element(aws_subnet.private-subnets[*].id, count.index) ### it will take the first element from the private subnets list and associate it with the private route table
  route_table_id    = aws_route_table.private-rt.id 
}

###create security group for the public subnets
resource "aws_security_group" "allow_all_sg" {
  vpc_id = aws_vpc.vpc1.id
  name   = "${local.vpc_name}-allow-all-sg"
  tags = {
    Name = "${local.vpc_name}-allow-all-sg"
    Env  = local.env
  }

  ###allow all inbound and outbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}