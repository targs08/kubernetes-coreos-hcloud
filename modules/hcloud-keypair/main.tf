provider "hcloud" {
  token = "${var.HCLOUD_TOKEN}"
}

resource "hcloud_ssh_key" "ssh_key" {
  name = "${var.ssh_key_name}"
  public_key = "${file(var.ssh_public_key)}"


  lifecycle {
      create_before_destroy = true
  }
}