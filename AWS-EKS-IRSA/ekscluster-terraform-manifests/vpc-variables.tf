#VPC input variables

variable "vpc_name" {

  description = "VPC name"
  type = string
  default = "myvpc"

}

#VPC_CIDR_BLOCK

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type = string
  default = "10.0.0.0/16"
}


# variable "vcp_availability_zones" {
#     description = "VPC Availability Zones"
#     type = list(string)
#     default = [ "eu-central-1a", "eu-central-1b" ]
  
# }


variable "vpc_public_subnets" {

    description = "VPC Public Subnets"
    type = list(string)
    default = [ "10.0.101.0/24","10.0.102.0/24" ]
  
}

variable "vpc_private_subnets" {
  
  description = "VPC private subnets"
  type = list(string)
  default = [ "10.0.1.0/24","10.0.2.0/24" ]

}

variable "vpc_database_subnets" {
  
  description = "VPC database subnets"
  type = list(string)
  default = [ "10.0.151.0/24","10.0.152.0/24" ]

}


variable "vpc_create_database_subnet_group" {
    description = "VPC Create Database subnet group"
    type = bool
    default = true
  
}

variable "vpc_create_database_subnet_route_table" {
    description = "VPC Create Database route table"
    type = bool
    default = true
  
}

variable "vpc_enable_nat_gateway" {
    description = "VPC Enable Nat gateway"
    type = bool
    default = true
  
}
variable "vpc_single_nat_gateway" {
    description = "VPC Enable single Nat gateway in one Availability zone"
    type = bool
    default = true
  
}
  
