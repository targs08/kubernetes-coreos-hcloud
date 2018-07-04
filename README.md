### Kubernets Cluster on Hetzner Cloud ###

* OS: CoreOS
* StorageDriver: OpenEbs

### Requirements ###

* terraform
* terraform hcloud plugin
* terraform helm pluging
* ansible
* kubespray (https://github.com/kubernetes-incubator/kubespray)


### Terraform ###

#### Init ####

```
terraform init
terraform plan -var HCLOUD_TOKEN=your token
terraform apply -var HCLOUD_TOKEN=your token
```

#### destroy ####

```
terraform destroy -target module.hcloud-server-master -target module.hcloud-server-worker
```

### Jenkins ###

Use Jeninsfile for create clister via Jenkins
