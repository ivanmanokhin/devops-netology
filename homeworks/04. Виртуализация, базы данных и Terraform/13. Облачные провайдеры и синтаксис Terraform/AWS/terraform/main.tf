provider "aws" {
  profile   = "default"
  region    = "eu-north-1"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "image" {
  most_recent   = true

  filter {
    name     = "name"
    values   = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name     = "virtualization-type"
    values   = ["hvm"]
  }

  owners   = ["099720109477"] # Canonical
}

resource "aws_vpc" "vpc" {
  cidr_block             = "10.10.0.0/16"
  enable_dns_hostnames   = true
  enable_dns_support     = true

  tags     = {
    Name   = "main-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id       = aws_vpc.vpc.id
  cidr_block   = "10.10.10.0/24"

  tags     = {
    Name   = "main-subnet"
  }
}

resource "aws_security_group" "security_group" {
  name     = "allow-all-sg"
  vpc_id   = "${aws_vpc.vpc.id}"

  ingress {
    cidr_blocks   = [
      "0.0.0.0/0"
    ]
    from_port     = 22
      to_port     = 22
      protocol    = "tcp"
  }

  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  ami                      = data.aws_ami.image.id
  instance_type            = "t3.micro"
  key_name                 = "manokhin-key"
  vpc_security_group_ids   = [aws_security_group.security_group.id]
  subnet_id                = "${aws_subnet.subnet.id}"

  tags     = {
    Name   = "ubuntu-instance-00"
  }
}


resource "aws_eip" "eip" {
  instance   = "${aws_instance.instance.id}"
  vpc        = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id   = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "route-table" {
  vpc_id   = "${aws_vpc.vpc.id}"

  route {
      cidr_block   = "0.0.0.0/0"
      gateway_id   = "${aws_internet_gateway.gw.id}"
    }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id        = "${aws_subnet.subnet.id}"
  route_table_id   = "${aws_route_table.route-table.id}"
}
