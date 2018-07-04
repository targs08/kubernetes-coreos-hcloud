data "template_file" "template-inventory" {
    template = "${file("${path.module}/templates/inventory.tpl")}"

    vars {
        connection_strings_master = "${join("\n",formatlist("%s ansible_host=%s",  var.master-nodes_name, var.master-nodes_ipv4_address))}"
        connection_strings_worker = "${join("\n", formatlist("%s ansible_host=%s", var.worker-nodes_name, var.worker-nodes_ipv4_address))}"
        list_master = "${join("\n",var.master-nodes_name)}"
        list_worker = "${join("\n",var.worker-nodes_name)}"
    }
}

data "template_file" "template-group" {
    template = "${file("${path.module}/templates/all.yml")}"

    vars {
        docker_dns_servers_strict = "${"${length(var.master-nodes_name)}" + "${length(var.worker-nodes_name)}" >= 3 ? false : true}"
        authorization_modes = "${jsonencode("${var.authorization_modes}")}"
    }
}

data "template_file" "template-k8s-cluster" {
    template = "${file("${path.module}/templates/k8s-cluster.yml")}"
}

resource "local_file" "kubespray-inventory-file" {
    content     = "${data.template_file.template-inventory.rendered}"
    filename = "${var.ansible_kubespray_inventory_path}/hosts.ini"
}
resource "local_file" "kubespray-group-all-file" {
    content     = "${data.template_file.template-group.rendered}"
    filename = "${var.ansible_kubespray_inventory_path}/group_vars/all.yml"
}
resource "local_file" "kubespray-group-file" {
    content     = "${data.template_file.template-k8s-cluster.rendered}"
    filename = "${var.ansible_kubespray_inventory_path}/group_vars/k8s-cluster.yml"
}

resource "null_resource" "ansible-execute" {
    depends_on = [ "local_file.kubespray-inventory-file", "local_file.kubespray-group-all-file", "local_file.kubespray-group-all-file"  ]
    provisioner "local-exec" {
        command = <<EOT
            ansible-playbook -i ${path.root}/artifacts/ansible/hosts.ini --private-key '${var.ssh_key_private}' cluster.yml \
            -b --become-user=root --flush-cache -e ansible_ssh_user=core -e cluster_name='${var.cluster_name}.local' \
        EOT
        environment {
            ANSIBLE_HOST_KEY_CHECKING = "False"
        }
        working_dir = "${var.ansible_kubespray_path}"
    }

}