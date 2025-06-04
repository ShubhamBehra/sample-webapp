pipeline {
    agent any

    environment {
        IMAGE_NAME = 'shubhambehra/webapp:v1'
        DOCKER_CREDENTIALS_ID = 'docker-credentials'
    }

    stages {
        stage('Clone git') {
            steps {
                git 'https://github.com/ShubhamBehra/sample-webapp.git'
            }
        }

        stage('Build WAR') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t webapp:v1 .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat '''
                        docker tag webapp:v1 shubhambehra/webapp:v1
                        docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                        docker push shubhambehra/webapp:v1
                    '''
                }
            }
        }

        stage('Deploy to K8s') {
            steps {
                bat 'kubectl apply -f k8-deploy.yaml --validate=false --server-side --kubeconfig=C:\\Users\\shubh\\.kube\\config'
                bat 'kubectl apply -f k8-service.yaml --validate=false --server-side --kubeconfig=C:\\Users\\shubh\\.kube\\config'
                bat 'kubectl rollout status deployment/webapp-deployment --kubeconfig=C:\\Users\\shubh\\.kube\\config'
            }
        }
    }
}
