output "instance_id" {
  value = aws_instance.private_instance.id
}

output "private_ip" {
  value = aws_instance.private_instance.private_ip
}

output "ssh_note" {
  value = "Use Bastion or SSM to connect (No Public IP)"
}
