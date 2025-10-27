# outputs.tf

# Public IP for SSH access
output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance (for SSH access)"
  value       = aws_instance.public_ec2.public_ip
}

# Public DNS for HTTP (Apache test)
output "ec2_public_dns" {
  description = "Public DNS name of the EC2 instance (use this for HTTP access)"
  value       = aws_instance.public_ec2.public_dns
}

# Optional: Instance ID (for AWS CLI or console reference)
output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.public_ec2.id
}

# Optional: Key pair used
output "ec2_key_name" {
  description = "SSH key pair name used to access the instance"
  value       = aws_instance.public_ec2.key_name
}