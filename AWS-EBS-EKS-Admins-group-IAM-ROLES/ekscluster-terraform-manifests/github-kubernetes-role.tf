# Creates a kubernetes cluster role with necessary access to deploy
resource "kubernetes_cluster_role" "github_oidc_cluster_role" {
    metadata {
        name = "github-oidc-cluster-role"
    }

    rule {
        api_groups  = ["*"]
        resources   = ["deployments","pods","services","namespaces","secrets","configmaps","storageclasses","persistentvolumeclaims"]
        verbs       = ["get", "list", "watch", "create", "update", "patch", "delete"]
    }
}

# Creates a cluster role binding between the above kubernetes cluster role and the user
resource "kubernetes_cluster_role_binding" "github_oidc_cluster_role_binding" {
  metadata {
    name = "github-oidc-cluster-role-binding"
  }

  subject {
    kind = "User"
    name =  "github-oidc-auth-user"
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.github_oidc_cluster_role.metadata[0].name
  }
}

# Uncomment to manage otherwise keep it commented out for destroy


# resource "kubernetes_config_map_v1_data" "aws-auth" {
#   data = {
#     "mapRoles" = yamlencode([
#       {
#         "groups": ["system:bootstrappers", "system:nodes"],
#         "rolearn": data.terraform_remote_state.eks.outputs.eks_nodegroup_role_arn
#         "username": "system:node:{{EC2PrivateDNSName}}"
#       },
#       {
#         "rolearn": aws_iam_role.github_oidc_auth_role.arn
#         "username": "github-oidc-auth-user"
        
#       }
#     ])

#     "mapAccounts" = yamlencode([])
#     "mapUsers" = yamlencode([])
#   }

#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
   
#   }
#   force=true
#   lifecycle {
#         prevent_destroy = true
#     }
# }



# apiVersion: v1
# data:
#   mapRoles: |
#     - groups:
#       - system:bootstrappers
#       - system:nodes
#       rolearn: arn:aws:iam::xxxxxxxxx:role/hr-dev-eks-nodegroup-role
#       username: system:node:{{EC2PrivateDNSName}}
#     - rolearn: arn:aws:iam::xxxxxxxxxxxxx:role/github-oidc-auth-role
#       username: github-oidc-auth-user
# kind: ConfigMap
