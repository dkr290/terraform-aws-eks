#AWS Region
variable "aws_region" {

  description = "Region in which AWS resources to be created"
  type        = string
  default     = "eu-central-1"

}
# Environment varialbe
variable "environment" {
  description = "Environemnt Variable used as prefix"
  type = string
  default = "dev"
  
}

#Business Devision

variable "business_division" {

  description = "Business division in the large organization"
  type = string
  default = "Operations"
  
}