[all]
${connection_strings_master}
${connection_strings_worker}

[kube-master]
${list_master}

[kube-ingress]
${list_master}

[kube-node]
${list_master}
${list_worker}


[etcd]
${list_master}


[k8s-cluster:children]
kube-node
kube-master
kube-ingress


[k8s-cluster:vars]