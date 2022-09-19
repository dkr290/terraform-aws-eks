resource "aws_instance" "ec2_public_instance" {
  ami           = data.aws_ami.amzn2-ami-kernel.id
  instance_type = var.instance_type
  key_name = var.instance_keypair
  security_groups = [ aws_security_group.allow_ssh.id ]
  subnet_id = module.vpc.public_subnets[0]

  tags = local.common_tags
}