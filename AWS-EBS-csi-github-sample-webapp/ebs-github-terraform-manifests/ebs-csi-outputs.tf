output "ebs_csi_helm_metadata" {
    description = "Metadata Block outlining status of deployining release"
    value = helm_release.ebs_csi_driver.metadata
}