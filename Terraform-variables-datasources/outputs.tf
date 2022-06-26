# EC2 instance IP

output "ec2_public_ip" {
  description = "EC2 instance public ip"
  value       = aws_instance.ec2demoinstance.public_ip
}

# Ec2 public DNS
output "ec2_public_dns" {
  description = "EC2 instance public dns"
  value       = aws_instance.ec2demoinstance.public_dns
}
