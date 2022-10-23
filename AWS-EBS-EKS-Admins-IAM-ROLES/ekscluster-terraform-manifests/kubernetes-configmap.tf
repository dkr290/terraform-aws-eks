data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

locals {
  configmap_roles = [
    {
        #rolearn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.eks_nodegroup_role.name}"
        rolearn = "${aws_iam_role.eks_nodegroup_role.arn}"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = ["system:bootstrappers", "system:nodes"]

    },
     {
     rolearn: "${aws_iam_role.github_oidc_auth_role.arn}"
     username: "github-oidc-auth-user"
        
    }    

  ]
  configmap_user = [
        {
        userarn = "${aws_iam_user.admin_user.arn}"
       username = "${aws_iam_user.admin_user.name}"
        groups =["system:masters"]
        },
        {
       userarn = "${aws_iam_user.basic_user.arn}"
       username = "${aws_iam_user.basic_user.name}"
       groups =["system:masters"]
      }

  ]

}

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles =yamlencode(local.configmap_roles)
    mapUsers= yamlencode(local.configmap_user)
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}



