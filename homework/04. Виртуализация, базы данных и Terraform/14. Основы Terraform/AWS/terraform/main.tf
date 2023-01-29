provider "aws" {
  profile   = "default"
  region    = "eu-north-1"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_instance" "ubuntu_instance" {
  ami                      = data.aws_ami.ubuntu.id
  instance_type            = local.instance_type_map[terraform.workspace]
  key_name                 = "ssh-key"
  count                    = local.instance_count_map[terraform.workspace]
  vpc_security_group_ids   = [aws_security_group.security_group.id]
  subnet_id                = "${aws_subnet.subnet.id}"

  tags     = {
    Name   = "[${terraform.workspace}]-ubuntu-instance-${count.index}"
  }
}

resource "aws_instance" "amazon_linux_instance" {
  for_each = local.instances[terraform.workspace]
  ami                      = data.aws_ami.amazon-linux.id
  instance_type            = each.value
  key_name                 = "ssh-key"
  vpc_security_group_ids   = [aws_security_group.security_group.id]
  subnet_id                = "${aws_subnet.subnet.id}"

  lifecycle {
    create_before_destroy  = true
  }

  tags     = {
    Name   = "[${terraform.workspace}]-amazon-linux-instance-${each.key}"
  }
}
