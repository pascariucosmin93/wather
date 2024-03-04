pipeline {
    agent any
    
    environment {
        registry = "registry.cosmin-lab.cloud:5000"
        dockerImage = "wather-app"
        dockerCredentials = 'docker-registry' // ID-ul de acreditare pentru Docker
        kubeconfigId = 'KUBECONFIG' // ID-ul kubeconfig
        kubeConfigs = 'prod1.yaml' // Fișierul de configurație Kubernetes YAML
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
                    dockerImage = docker.build("${registry}/${dockerImage}:1")
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
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Definiți comanda kubectl pentru a implementa resursele Kubernetes din fișierul myweb.yaml
                    def deployCommand = "kubectl apply -f prod1.yaml"
                    
                    // Executați comanda utilizând sh
                    sh deployCommand
                }
            }
        }
    }