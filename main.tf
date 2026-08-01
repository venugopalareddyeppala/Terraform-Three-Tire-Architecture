#############
### VPC ####
############

resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC"
  }

}


################
### SUBNET'S ###
################

####################################
### PUBLIC SUBNET'S FOR WEB-TIRE ###
####################################

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet2"
  }
}


####################################
### PRIVATE SUBNET'S FOR APP-TIRE###
####################################

resource "aws_subnet" "private_subnet3" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_subnet3_cidr
  availability_zone = "us-west-1a"

  tags = {
    Name = "private-subnet3"
  }

}


resource "aws_subnet" "private_subnet4" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_subnet4_cidr
  availability_zone = "us-west-1c"

  tags = {
    Name = "private-subnet4"
  }

}



####################################
### PRIVATE SUBNET'S FOR DB-TIRE ###
####################################

resource "aws_subnet" "private_subnet5" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_subnet5_cidr
  availability_zone = "us-west-1a"

  tags = {
    Name = "private-subnet5"
  }

}

resource "aws_subnet" "private_subnet6" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_subnet6_cidr
  availability_zone = "us-west-1c"

  tags = {
    Name = "private-subnet6"
  }

}



########################
### INTERNET GATEWAY ###
########################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "igw"
  }
}






###################
### NAT GATEWAY ###
###################

resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet2.id
  tags = {
    Name = "nat"
  }
}





####################
### ROUTE TABLES ###
####################

###########################################
### PUBLIC ROUTE TABLE FOR WEB TIRE - 1 ###
###########################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PUBLIC-RT"
  }
}

######################################
### PUBLIC ROUTE TABLE ASSOCIATION ###
######################################

resource "aws_route_table_association" "rt_public1_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_public2_association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}



##################################################
### PRIVATE ROUTE TABLE FOR APP TIRE & DB TIRE ###
##################################################

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "PRIVATE-RT"
  }
}
#######################################
### PRIVATE ROUTE TABLE ASSOCIATION ###
#######################################

resource "aws_route_table_association" "rt_private3_association" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "rt_private4_association" {
  subnet_id      = aws_subnet.private_subnet4.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "rt_private5_association" {
  subnet_id      = aws_subnet.private_subnet5.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "rt_private6_association" {
  subnet_id      = aws_subnet.private_subnet6.id
  route_table_id = aws_route_table.private_rt.id
}




########################
### SECURITY GROUP's ###
########################

resource "aws_security_group" "sg" {
  name        = "security-group"
  description = "Allow SSH, HTTP, HTTPS and MySQL"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    description = "Access for SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access for HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access for HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access for MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG"
  }
}