resource "kubernetes_job" "irsa_demo" {
  metadata {
    name = "irsa-demo"
  }
  spec {
    template {
      metadata {
        labels = {
            app="irsa-demo"
        }
      }
      spec {
        service_account_name = kubernetes_service_account.irsa_demo_sa.metadata[0].name
        container {
          name    = "irsa-demo"
          image   = "amazon/aws-cli:latest"
          args = [ "s3","ls" ]
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 4
  }
  wait_for_completion = false

}