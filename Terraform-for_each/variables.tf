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

## Defining  AWS instance type - list

variable "instance_type_list" {
  description = "EC2 Instance type list"
  type        = list(string)
  default     = ["t3.micro", "t3.small", "t3.large"]

}

## Defining Instance type - map
variable "instance_type_map" {
  description = "EC2 Instance Type"
  type        = map(string)
  default = {
    "dev"  = "t3.micro"
    "qa"   = "t3.small"
    "prod" = "t3.large"
  }
}
