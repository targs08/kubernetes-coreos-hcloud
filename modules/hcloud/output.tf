
output "servers_name" {
  value = "${hcloud_server.servers.*.name}"
}

output "ipv4_address" {
  value = "${hcloud_server.servers.*.ipv4_address}"
}
