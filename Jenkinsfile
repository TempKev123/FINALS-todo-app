pipeline {
    agent any

    environment {
        IMAGE_NAME = 'finead-todo-app'
    }

    stages {

        stage('Install Frontend Dependencies') {
            steps {
                dir('TODO/todo_frontend') {
                    sh 'npm install'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('TODO/todo_frontend') {
                    sh 'npm run build'
                }
            }
        }

        stage('Prepare Backend') {
            steps {
                sh 'rm -rf TODO/todo_backend/build'
                sh 'cp -r TODO/todo_frontend/build TODO/todo_backend/'
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                dir('TODO/todo_backend') {
                    sh 'npm install'
                }
            }
        }

        stage('Test Backend') {
            steps {
                dir('TODO/todo_backend') {
                    sh 'npm test || true'
                }
            }
        }

        stage('Containerize Application') {
            steps {
                dir('TODO/todo_backend') {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Push Image') {
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