output "kubeconfig" {
    value = "${var.ansible_kubespray_inventory_path}/artifacts/admin.conf"
}