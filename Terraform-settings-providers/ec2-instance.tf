resource "aws_instance" "ec2demoinstance" {

  ami           = "ami-0a1ee2fb28fe05df3"
  instance_type = "t3.micro"
  user_data     = file("${path.module}/app1-install.sh")
  # key_name      = "eks-course1"

  tags = {
    "Name" = "EC2 Demo instance"
  }


}