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
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t webapp:v1 .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "$DOCKER_CREDENTIALS_ID",
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh 'docker tag webapp:v1 shubhambehra/webapp:v1'
                    sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                    sh 'docker push shubhambehra/webapp:v1'
                }
            }
        }


        stage('Deploy to K8s') {
            steps {
                // Apply deployment and NodePort service YAMLs
                sh 'kubectl apply -f k8-deploy.yaml'
                sh 'kubectl apply -f k8-service.yaml'
                
                // Wait for deployment rollout to finish
                sh 'kubectl rollout status deployment/webapp-deployment'
            }
        }

    }
}                                                                                                                                   