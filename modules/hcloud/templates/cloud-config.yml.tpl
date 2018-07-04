#cloud-config

hostname: "${hostname}"

coreos:
  units:
    - name: "iscsid.service"
      command: "start"
      runtime: true
      enable: true

ssh_authorized_keys:
  - ${ssh_key_public}
