#For authenticating your GitHub Actions workflow, you can either use the access key id and secret access key of your AWS account or configure 
#GitHub OpenID Connect (OIDC) as trusted external identity provider in AWS IAM and use its id-token to get the short-lived credentials from 
#AWS Security Token Service (STS).
#We should create an AWS IAM Role and assign a Role Policy that defines its permissions. 
#The short-lived credentials will have exact permissions as the AWS IAM Role.

#Our requirement is to identify the EKS clusters that exist under our account and get information about them. 
#eks:ListClusters and eks:DescribeCluster role policies allow us to fetch this information.

#To configure GitHub OIDC as an external identity provider and to create an AWS IAM Role with its policies as follows

# Configure AWS Credentials Action requests token with audience sts.amazonaws.com. aud field of the token
# Thumbprint is the signature for CA's certificate. More info @ https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
# Url is url of the id token provider. iss field of the token
resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["15E29108718111E59B3DAD31954647E3C344A231"]
  url             = "https://token.actions.githubusercontent.com"
}

# The values field under condition is used to allow access for workflow triggered from specific repo and environment or branch or tag or "pull_request"
# For more info @ https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#example-subject-claims
data "aws_iam_policy_document" "github_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.github.url, "https://", "")}:sub"
      values   = ["repo:dkr290/mlflow-cicd:*"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.github.arn]
      type        = "Federated"
    }
  }
}

# Create a role policy that would allow fetching cluster info. 
# This would help us avoid storing cluster's kube config in GitHub Action's secrets
resource "aws_iam_role_policy" "github_oidc_eks_policy" {
    name = "github-oidc-eks-policy"
    role = aws_iam_role.github_oidc_auth_role.id

    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": "eks:DescribeCluster",
                "Resource": "arn:aws:eks:*:*:cluster/*"
            },
            {
                "Sid": "VisualEditor1",
                "Effect": "Allow",
                "Action": "eks:ListClusters",
                "Resource": "*"
            }
        ]
    })
}

# Creating a role. It will used as value to role_to_assume for Configure AWS Crendentials action.
resource "aws_iam_role" "github_oidc_auth_role" {
  assume_role_policy = data.aws_iam_policy_document.github_assume_role_policy.json
  name               = "github-oidc-auth-role"
}