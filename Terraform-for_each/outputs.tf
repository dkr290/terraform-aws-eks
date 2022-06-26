

output "instnance_publicip" {
  description = "EC2 instance public IP"
 # value       = aws_instance.ec2demoinstance.*.public_ip
 value = [for instance in aws_instance.ec2demoinstance: instance.public_ip]
}

# Output the latest splat operator

output "instance_publicdns" {
  value = [for instance in aws_instance.ec2demoinstance: instance.public_dns]
}


output "instance_publicdns2" {

  value = { for az, instance in aws_instance.ec2demoinstance: az => instance.public_dns }
  
}