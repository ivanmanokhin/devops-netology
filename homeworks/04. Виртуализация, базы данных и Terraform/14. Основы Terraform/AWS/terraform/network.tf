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

resource "aws_eip" "ubuntu_instance_eip" {
  count      = local.instance_count_map[terraform.workspace]
  instance   = "${aws_instance.ubuntu_instance[count.index].id}"
  vpc        = true
}

resource "aws_eip" "amazon_linux_instance_eip" {
  for_each   = local.instances[terraform.workspace]
  instance   = "${aws_instance.amazon_linux_instance[each.key].id}"
  vpc        = true
}
