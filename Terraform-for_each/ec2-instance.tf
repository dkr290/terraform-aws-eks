data "aws_availability_zones" "my_az" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_instance" "ec2demoinstance" {
  for_each = toset(data.aws_availability_zones.my_az.names)
  ami   = data.aws_ami.amz_linux2s.id
  #instance_type = var.instance_type
  instance_type = var.instance_type_list[1] #this is for the list
  #instance_type = var.instance_type_map["prod"] ## for map
  user_data              = file("${path.module}/app1-install.sh")
  key_name               = var.instance_keypair
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  availability_zone = each.key
  tags = {
    "Name" = "EC2-Demo-${each.value}"
  }


}