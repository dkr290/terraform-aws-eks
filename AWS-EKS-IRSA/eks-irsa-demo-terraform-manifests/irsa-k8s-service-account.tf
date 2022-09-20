resource "kubernetes_service_account" "irsa_demo_sa" {
  metadata {
    name = "irsa-demo-sa"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_iam_role.arn
    }
  }
  depends_on = [
   aws_iam_role_policy_attachment.irsa_iam_role_policy_attach
  ]

}
