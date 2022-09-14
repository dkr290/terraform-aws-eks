resource "aws_security_group" "allow_ssh" {
  name        = "${local.name}-public_bastion_sg"
  description = "Public bastion inbound ssh port traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "22 from internet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags =local.common_tags
}