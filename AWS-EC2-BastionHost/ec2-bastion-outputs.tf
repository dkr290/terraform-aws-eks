output "primary_network_interface_id"{
    description = "primary network interface"
    value = aws_instance.ec2_public_instance.primary_network_interface_id
}

output "private_dns"{
    description = "private dns ip"
    value = aws_instance.ec2_public_instance.private_dns
}

output "private_ip" {
    description = "private ip address"
    value = aws_instance.ec2_public_instance.private_ip
}


output "public_ip" {
    description = "public ip adress"
    value = aws_instance.ec2_public_instance.public_ip
}
