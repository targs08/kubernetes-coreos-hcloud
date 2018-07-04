
output "master-ip" {
  value = "${module.hcloud-server-master.ipv4_address}"
}

output "worker-ip" {
    value = "${module.hcloud-server-worker.ipv4_address}"
}

output "kubernetes-dashboard" {
    value = "https://${module.hcloud-server-worker.ipv4_address[0]}:6443/ui"
}