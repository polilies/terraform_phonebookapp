#it might return failure due to non-existance fo the ami in the myami

provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

locals {
  mytag = "clarusway-local-name"
}

data "aws_ami" "tf_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}

variable "ec2_type" {
  default = "t2.micro"
}

#variable "MyDBURI" {}

/*
resource "aws_security_group" "phonebook" {
  name        = "allow_http"
  description = "Allow TLS inbound traffic"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description = "Http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks      = [aws_vpc.main.cidr_block]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks      = [aws_vpc.main.cidr_block]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
*/
locals {
  keyname = "nvirginia"
}

resource "aws_instance" "tf-ec2" {
  ami             = data.aws_ami.tf_ami.id
  instance_type   = var.ec2_type
  key_name        = local.keyname
  private_ip = "10.0.10.100"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subnets[0].id
  #security_groups = ["${aws_security_group.web.name}"]
  vpc_security_group_ids = ["${aws_security_group.web.id}"] #only if we create our own vpc not the defautl one
  tags = {
    Name = "${local.mytag}-this is from my-ami"
  }

  /* network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  } */
  user_data  = file("user.sh")
  depends_on = [aws_internet_gateway.gw]
}

output "public_ip" {
  value = aws_instance.tf-ec2.public_ip
}

