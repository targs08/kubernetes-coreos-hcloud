provider "helm" {
    kubernetes {
        config_path = "${var.kubernetes_config}"
    }
}

resource "helm_repository" "openebs-repo" {
    name = "openebs"
    url  = "https://openebs.github.io/charts/"
}

resource "helm_release" "openebs" {
    depends_on = [ "helm_repository.openebs-repo" ]
    name       = "openebs"
    repository = "${helm_repository.openebs-repo.metadata.0.name}"
    chart      = "openebs"
    version    = "${var.chart_version}"
    provisioner "local-exec" {
        command = "sleep 60"
    }
}

resource "null_resource" "storageclass-default" {
    depends_on = [ "helm_release.openebs"  ]
    provisioner "local-exec" {
        command = <<EOT
            kubectl patch storageclass openebs-standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
        EOT
        environment {
            KUBECONFIG = "${var.kubernetes_config}"
        }
    }
}