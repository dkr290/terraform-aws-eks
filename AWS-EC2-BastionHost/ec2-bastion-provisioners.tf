resource "null_resource" "copy_ec2_keys" {
  depends_on = [
    aws_instance.ec2_public_instance
  ]
  connection {
    type = "ssh"
    host = aws_eip.bastion_eip.public_ip
    user = "ec2_user"
    password = ""
    private_key = file("private-key/eks-terraform-key.pem")
  }

 provisioner "file" {
    source = "private-key/eks-terraform-key.pem"
    destination = "/tmp/eks-terraform-key.pem"
   
 }

 provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/eks-terraform-key.pem"
    ]
   
 }

 provisioner "local-exec" {

    command = "echo vpc created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-file"
   
 }
}

