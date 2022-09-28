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
 
}

provider "helm" {
  # Configuration options
}
  }

backend "s3" {
  bucket = "terraform-infrastate80"
  key = "dev/ebs-storage/terraform.tfstate"
  region = "eu-central-1"
  
}




provider "aws" {
  # Configuration options
  region  = var.aws_region
  profile = "default"


}



