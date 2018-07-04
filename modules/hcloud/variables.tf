
variable "HCLOUD_TOKEN" { }
variable "HCLOUD_AVAILABLE_DC" {
    type = "list"
    default = ["fsn1-dc8", "nbg1-dc3", "hel1-dc2"]
}

variable "HCLOUD_INSTANCE_TYPE" { }

variable "HCLOUD_KEYPAIR" { }

variable "servers_count" { }

variable "servers_name_prefix" { }

variable "ssh_key_private" { }

variable "ssh_key_public" { }


