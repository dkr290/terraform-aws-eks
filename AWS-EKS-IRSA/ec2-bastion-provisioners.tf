resource "null_resource" "copy_ec2_keys" {
  depends_on = [
    aws_instance.ec2_public_instance
  ]
  connection {
    type = "ssh"
    host = aws_eip.bastion_eip.public_ip
    user = "ec2-user"
    password = ""
    private_key = file("private-key/eks-key.pem")
  }

 provisioner "file" {
    source = "private-key/eks-key.pem"
    destination = "/tmp/eks-key.pem"
   
 }

 provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/eks-key.pem"
    ]
   
 }

 provisioner "local-exec" {

    command = "echo vpc created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-file"
   
 }
}

