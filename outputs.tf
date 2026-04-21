output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.private_instance.id
}
 
output "private_ip" {
  description = "Private IP of EC2 Instance"
  value       = aws_instance.private_instance.private_ip
}
 
output "ssh_note" {
  description = "Reminder: use Bastion or SSM to connect"
  value       = "Use Bastion or SSM to connect — No Public IP assigned"
}
