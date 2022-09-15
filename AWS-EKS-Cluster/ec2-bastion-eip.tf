resource "aws_eip" "bastion_eip" {
  instance = aws_instance.ec2_public_instance.id
  vpc      = true
  tags = local.common_tags

  depends_on = [
   aws_instance.ec2_public_instance,
   module.vpc
  ]
}