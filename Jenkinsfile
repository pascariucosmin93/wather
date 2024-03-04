pipeline {
    agent any
    
    environment {
        registry = "registry.cosmin-lab.cloud:5000"
        dockerImage = "prod1"
        dockerCredentials = 'docker-registry' // ID-ul de acreditare pentru Docker
        kubeconfigId = 'KUBECONFIG' // ID-ul kubeconfig

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
                    
                    def deployCommand = "kubectl apply -f prod1.yaml"
                    
                  
                    sh deployCommand
                }
            }
        }
    }
}
