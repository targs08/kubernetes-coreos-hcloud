variable "HCLOUD_TOKEN" { }

variable "cluster_name" { }

variable "master_servers_name" { }
variable "master_servers_count" { }
variable "master_instance_type" { }

variable "worker_servers_name" { }
variable "worker_servers_count" { }
variable "worker_instance_type" { }

variable "ssh_key_private" { 
    default = "~/.ssh/id_rsa"
}

variable "ssh_key_public" { 
    default = "~/.ssh/id_rsa.pub"
}

variable "kubespray_path" { }