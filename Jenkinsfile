pipeline {
    agent any

    environment {
        IMAGE_NAME = 'finead-todo-app'
    }

    stages {
        stage('Build') {
            steps {
                echo 'Building the application...'

                // Install dependencies
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                echo 'Running unit tests...'

                // If tests fail here, the pipeline will stop automatically
                sh 'npm test'
            }
        }

        stage('Containerize Application') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                    docker tag ${IMAGE_NAME}:latest $DOCKER_USER/${IMAGE_NAME}:latest

                    docker push $DOCKER_USER/${IMAGE_NAME}:latest

                    docker logout
                    '''
                }
            }
        }

    }
}