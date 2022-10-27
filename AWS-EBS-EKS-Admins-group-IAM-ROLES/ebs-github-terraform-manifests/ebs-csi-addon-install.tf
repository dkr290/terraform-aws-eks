data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

resource "aws_eks_addon" "ebs_eks_addon" {
  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_id
  addon_name        = "aws-ebs-csi-driver"
 depends_on = [
   aws_iam_role_policy_attachment.ebs_csi_iam_role_policy_attachm
 ]
 service_account_role_arn = aws_iam_role.ebs_csi_iam_role.arn
}