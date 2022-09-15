variable "instance_type" {
   description = "EC2 instance type"
   type = string
   default = "t3.micro"
}


variable "instance_keypair" {
    description = "EC2 instance keypair"
    type = string
    default = "eks-key"
  
}