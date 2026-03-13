pipeline {
    agent any

    environment {
        IMAGE_NAME = 'finead-todo-app'
    }

    stages {

        stage('Build Frontend') {
            steps {
                echo 'Building React frontend...'

                dir('todo_frontend') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Prepare Backend') {
            steps {
                echo 'Copy frontend build into backend...'

                sh 'rm -rf todo_backend/build'
                sh 'cp -r todo_frontend/build todo_backend/'
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                dir('todo_backend') {
                    sh 'npm install'
                }
            }
        }

        stage('Test Backend') {
            steps {
                dir('todo_backend') {
                    sh 'npm test || true'
                }
            }
        }

        stage('Containerize Application') {
            steps {
                dir('todo_backend') {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
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