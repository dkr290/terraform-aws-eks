## Output for loop 

output "for_output_public_dns_lists" {
  description = "for loop with list"
  value       = [for instance in aws_instance.ec2demoinstance : instance.public_dns]
}

# Output for loop map


output "for_loop_map1_public_dns_map" {
  description = "For loop map"
  value       = { for instance in aws_instance.ec2demoinstance : instance.id => instance.public_dns }
}


output "for_loop_map2" {
  description = "For loop with map advanced"
  value       = { for c, instance in aws_instance.ec2demoinstance : c => instance.public_dns }

}

# Output Legacy Splat Operator (Legacy) - Returns the list

output "legacy_splat_instance_publicip" {
  description = "Legacy splat operator"
  value       = aws_instance.ec2demoinstance.*.public_ip
}

# Output the latest splat operator

output "latest_splat_instance_publicip" {
  value = aws_instance.ec2demoinstance[*].public_ip
}