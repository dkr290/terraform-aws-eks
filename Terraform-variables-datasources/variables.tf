# AWS Region 

variable "aws_region" {

  description = "Region in which AWS resources to be created"
  type        = string
  default     = "eu-central-1"

}
# AWS EC2 instance type

variable "instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t3.micro"


}

#AWS instance keypair
variable "instance_keypair" {
  description = "AWS EC2 instance default keypair"
  type        = string
  default     = "eks-course1"

}