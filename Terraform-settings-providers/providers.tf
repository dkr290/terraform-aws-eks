terraform {
  required_version = "~> 1.2"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19"
      #alias   = "aws-eu-central"
    }
  }



}

provider "aws" {
  # Configuration options
  region  = "eu-central-1"
  profile = "default"


}



