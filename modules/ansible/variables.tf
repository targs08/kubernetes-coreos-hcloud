variable "cluster_name" { }

variable "master-nodes_name" {
  type = "list"
}

variable "master-nodes_ipv4_address" {
    type = "list"
}


variable "worker-nodes_name" {
  type = "list"
}

variable "worker-nodes_ipv4_address" {
    type = "list"
}

variable "ssh_key_private" { }

variable authorization_modes      {
  type = "list"
  default = [ "Node", "RBAC" ]
}
variable "ansible_kubespray_path" { }

variable "ansible_kubespray_inventory_path" {
  type = "string"
  default = "kubespray-inventory"
}
