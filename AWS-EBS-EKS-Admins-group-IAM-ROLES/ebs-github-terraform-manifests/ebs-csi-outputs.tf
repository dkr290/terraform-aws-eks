output "ebs_eks_addon_arn" {
    description = "EKS AddOn - EBS CSI driver ARN"
    value = aws_eks_addon.ebs_eks_addon.arn
}

output "ebs_eks_addon_id" {
    description = "EKS AddOn - EBS CSI Driver ID"
    value = aws_eks_addon.ebs_eks_addon.id
}