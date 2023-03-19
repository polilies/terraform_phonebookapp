##############################VARIABLES
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.11.0/24", "10.0.21.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "posix" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["1a", "1b"]
}

##############################VPC

resource "aws_vpc" "phone" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "phone"
  }
}
###################################IGW

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.phone.id

  tags = {
    Name = "main"
  }
}
################################SUBNETS

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.phone.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "phone-public-${element(var.posix, count.index)}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.phone.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "phone-private-${element(var.posix, count.index)}"
  }
}

/* resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.phone.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "phone-public1-az1a"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.phone.id
  cidr_block = "10.0.21.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "phone-private1-az1a"
  }
}
 */
##################################NETWORK INTERFACES
/* resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.public_subnets[0].id
  security_groups = 
  tags = {
    Name = "primary_network_interface"
  }
} */

###################################ROUTING TABLES
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.phone.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  /* route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.gw.id
  } */

  tags = {
    Name = "phone_public_rt"
  }
}


###################################ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public.id
}