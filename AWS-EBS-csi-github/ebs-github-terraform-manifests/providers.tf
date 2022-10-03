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

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.13.1"
      
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



provider "kubernetes" {
  # Configuration options
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode( data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.cluster.token
 
 
}