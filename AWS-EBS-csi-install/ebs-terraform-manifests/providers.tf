terraform {
  required_version = "~> 1.2"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19"
      #alias   = "aws-eu-central"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~> 2.7"
    }

      
    http = {
      source = "hashicorp/http"
      version = "~>3.1"
    }
  }
 
backend "s3" {
  bucket = "terraform-infrastate80"
  key = "dev/ebs-storage/terraform.tfstate"
  region = "eu-central-1"
  
}

  }





provider "aws" {
  # Configuration options
  region  = var.aws_region
  profile = "default"


}


provider "http" {
  # Configuration options
}



