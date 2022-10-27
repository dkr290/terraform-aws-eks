# Define local values in terraform
locals {
  owners = lower("${var.business_division}")
  environment = var.environment
  

 name = "${local.owners}-${local.environment}"
 common_tags ={
    owners = local.owners
    environment = local.environment
 }

   eks_cluster_name = "${data.terraform_remote_state.eks.outputs.cluster_id}"
}