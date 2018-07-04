pipeline {
    environment {
        HCLOUD_TOKEN = credentials('hcloud-token-k8s')
        DOCKER_REGISTRY_CREDS = credentials('registry-jenkins')
    }
    parameters {
        validatingString  name: 'CLUSTER_NAME', regex: '[a-z\\-1-9]{3,20}$', description: "Set server name. Example: k8s-cluster", failedValidationMessage: 'Use characters: a-z, 0-9, -; Lenght 3-20 symbols'
        string name: 'MASTER_COUNT', defaultValue: '3', description: 'Number of instances master node(3 for High-Availiable)', trim: true
        choice name: 'MASTER_TYPE',  choices: ['cx21', 'cx31', 'cx41', 'cx51'], description: 'Instance type for master nodes'
        string name: 'WORKER_COUNT', defaultValue: '1', description: 'Number of instances worker node(Recommendation 1. Zero value is possible)', trim: true
        choice name: 'WORKER_TYPE',  choices: ['cx21', 'cx31', 'cx41', 'cx51'], description: 'Instance type for worker nodes'
    }
    options {
        skipDefaultCheckout false
    }
    agent {
        docker {
            image 'targs08/terraform:latest'
            alwaysPull true
        }
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    currentBuild.displayName = "#${CLUSTER_NAME}"
                }
                dir("kubespray") {
                    git url: "https://github.com/targs08/kubespray.git"
                }
            }
        }
        stage('Terrafrom init') {
            post {
                always {
                        archiveArtifacts artifacts: 'terraform.tfstate'
                }
            }
            steps {
                withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'terraform-stage-private', keyFileVariable: 'HCLOUD_PRIVATE_KEY')]) {
                withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'terraform-stage-public',  keyFileVariable: 'HCLOUD_PUBLIC_KEY')]) {
                    sh "terraform init"
                    sh 'terraform apply -auto-approve \
                        -var \"HCLOUD_TOKEN=${HCLOUD_TOKEN}\" \
                        -var \"cluster_name=${CLUSTER_NAME}\" \
                        -var \"master_servers_name=${WORKER_COUNT}\" \
                        -var \"master_servers_count=${WORKER_COUNT}\" \
                        -var \"master_instance_type=${WORKER_TYPE}\" \
                        -var \"worker_servers_name=${WORKER_COUNT}\" \
                        -var \"worker_servers_count=${WORKER_COUNT}\" \
                        -var \"worker_instance_type=${WORKER_TYPE}\" \
                        -var \"kubespray_path=${WORKSPACE}/kubespray\" \
                        -var \"ssh_key_private=${HCLOUD_PRIVATE_KEY}\" \
                        -var \"ssh_key_public=${HCLOUD_PUBLIC_KEY}\"'
                    sh "terraform output master-ip > terraform.master.ip"
                    sh "terraform output worker-ip > terraform.worker.ip"
                    script {
                        master_ip = readFile('terraform.master.ip').trim()
                        worker_ip = readFile('terraform.worker.ip').trim()
                        currentBuild.displayName = "#${CLUSTER_NAME}"
                        currentBuild.description = "master ip:\n${master_ip}\n\nworker ip:\n${worker_ip}\n\n"
                    }
                }}
            }
        }
        stage('Collect kubespray artifacts') {
            steps {
                dir("kubespray-inventory") {
                    archiveArtifacts '**'
                }
            }
        }
    }
    post {
        always {
            cleanWs deleteDirs: true
        }
    }
}