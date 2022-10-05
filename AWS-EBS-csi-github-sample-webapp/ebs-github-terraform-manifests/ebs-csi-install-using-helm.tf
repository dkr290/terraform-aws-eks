resource "helm_release" "ebs_csi_driver" {
  name       = "${local.name}-aws-ebs-csi-driver"

  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  #chart      = "aws-ebs-csi-driver"
  chart    = "C:\\tools\\aws-ebs-csi-driver-2.11.1.tgz"
  namespace = "kube-system"

  set {
    name = "image.repository"
    value = "602401143452.dkr.ecr.eu-central-1.amazonaws.com/eks/aws-ebs-csi-driver"
  }

  set {
    name = "controller.serviceAccount.create"
    value = "true"
  }

  set {
    name = "controller.serviceAccount.name"
    value = "ebs-csi-controller-sa"
  }

  set {
    name = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.ebs_csi_iam_role.arn}"
  }

  depends_on = [ aws_iam_role.ebs_csi_iam_role ]
}