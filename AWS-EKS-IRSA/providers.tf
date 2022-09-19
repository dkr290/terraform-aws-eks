terraform {
  required_version = "~> 1.2"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19"
      #alias   = "aws-eu-central"
    }
  }

backend "s3" {
  bucket = "terraform-infrastate"
  key = "dev/eks-cluster/terraform.tfstate"
  region = "eu-central-1"
  
}


}

provider "aws" {
  # Configuration options
  region  = var.aws_region
  profile = "default"


}



