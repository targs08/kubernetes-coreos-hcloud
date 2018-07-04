
module "hcloud-ssh-key" {
    source = "modules/hcloud-keypair"
    HCLOUD_TOKEN = "${var.HCLOUD_TOKEN}"
    ssh_key_name = "${var.cluster_name}-key"
    ssh_public_key = "${var.ssh_key_public}"

}

module "hcloud-server-master" {
    source = "modules/hcloud"

    HCLOUD_TOKEN = "${var.HCLOUD_TOKEN}"
    HCLOUD_INSTANCE_TYPE = "${var.master_instance_type}"
    HCLOUD_KEYPAIR = "${module.hcloud-ssh-key.key}"
    servers_count = "${var.master_servers_count}"
    servers_name_prefix = "${var.master_servers_name}"

    ssh_key_private = "${var.ssh_key_private}"

    ssh_key_public = "${var.ssh_key_public}"

}

module "hcloud-server-worker" {
    source = "modules/hcloud"

    HCLOUD_TOKEN = "${var.HCLOUD_TOKEN}"
    HCLOUD_INSTANCE_TYPE = "${var.worker_instance_type}"
    HCLOUD_KEYPAIR = "${module.hcloud-ssh-key.key}"
    servers_count = "${var.worker_servers_count}"
    servers_name_prefix = "${var.worker_servers_name}"

    ssh_key_private = "${var.ssh_key_private}"

    ssh_key_public = "${var.ssh_key_public}"

}

module "kubespray-ansible" {
    source = "modules/ansible"

    cluster_name = "${var.cluster_name}"
    master-nodes_name = "${module.hcloud-server-master.servers_name}"
    master-nodes_ipv4_address = "${module.hcloud-server-master.ipv4_address}"
    worker-nodes_name = "${module.hcloud-server-worker.servers_name}"
    worker-nodes_ipv4_address = "${module.hcloud-server-worker.ipv4_address}"

    ssh_key_private = "${var.ssh_key_private}"

    ansible_kubespray_path = "${var.kubespray_path}"
}

module "helm-openebs" {
    source = "modules/openebs-chart"
    kubernetes_config = "${module.kubespray-ansible.kubeconfig}"
    chart_version = "0.5.3"
}
