resource "aws_instance" "ec2demoinstance" {
  count = 2
  ami   = data.aws_ami.amz_linux2s.id
  #instance_type = var.instance_type
  instance_type = var.instance_type_list[1] #this is for the list
  #instance_type = var.instance_type_map["prod"] ## for map
  user_data              = file("${path.module}/app1-install.sh")
  key_name               = var.instance_keypair
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  tags = {
    "Name" = "EC2-Demo-${count.index}"
  }


}