output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "region_name" {
  value = data.aws_region.current.name
}

output "ubuntu_instance_private_ip" {
  value = aws_instance.ubuntu_instance[*].private_ip
}

output "ubuntu_instance_public_ip" {
  value = aws_eip.ubuntu_instance_eip[*].public_ip
}

output "ubuntu_instance_public_dns" {
  value = aws_eip.ubuntu_instance_eip[*].public_dns
}

output "amazon_linux_instance_private_ip" {
  value = values(aws_instance.amazon_linux_instance).*.private_ip
}

output "amazon_linux_instance_public_ip" {
  value = values(aws_eip.amazon_linux_instance_eip).*.public_ip
}

output "amazon_linux_instance_public_dns" {
  value = values(aws_eip.amazon_linux_instance_eip).*.public_dns
}
