pipeline {
    agent any
    
    environment {
        registry = "registry.cosmin-lab.cloud:5000"
        dockerCredentials = 'docker-registry' // ID-ul de acreditare pentru Docker
        kubeconfigId = 'KUBECONFIG' // ID-ul kubeconfig
        kubeConfigs = 'prod1.yaml' // Fișierul de configurație Kubernetes YAML
        kubeConfigPath = "/var/lib/jenkins/.kube/config" // Definirea variabilei kubeConfigPath
    }
    
    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/pascariucosmin93/wather.git'
            }
        }
        
        stage('Build Image') {
            steps {
                script {
                    // Obține ultimul commit și primele 6 caractere din hash
                    def commitHash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    // Setează numele imaginii Docker
                    dockerImage = "wather-app:${commitHash}"
                    // Construiește imaginea Docker
                    dockerImage = docker.build("${registry}/${dockerImage}")
                }
            }
        }
        
        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('https://' + registry, dockerCredentials) {
                        dockerImage.push()
                    }
                }
            }
        }
        
        stage('Update YAML') {
            steps {
                script {
                    // Citim conținutul fișierului YAML într-o variabilă
                    def yamlContent = readFile("${kubeConfigs}")
                    
                    // Construim noul conținut YAML actualizat cu numele imaginii Docker
                    def updatedYamlContent = yamlContent.replaceAll(/dockerImage: .*/, "dockerImage: ${dockerImage}")
                    
                    // Suprascriem fișierul YAML cu conținutul actualizat
                    writeFile(file: "${kubeConfigs}", text: updatedYamlContent)
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Comanda de implementare a resurselor Kubernetes
                    def deployCommand = "kubectl --kubeconfig=${kubeConfigPath} apply -f prod1.yaml"
                    
                    // Executăm comanda folosind 'sh'
                    sh deployCommand
                }
            }
        }
    }
}
