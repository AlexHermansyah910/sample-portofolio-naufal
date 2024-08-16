pipeline {
    agent any

    environment {
        IMAGE_NAME = 'alexhermansyah/sampleportofolionaufal:latest'
        CONTAINER_NAME = 'sampleportofolionaufal'
        NETWORK_NAME = 'portofolio'
        DOCKER_USERNAME = credentials('usernamedocker')
        DOCKER_PASSWORD = credentials('passworddocker')
        EC2_HOST = '52.54.155.185'
        SSH_KEY_ID = 'remote-ec2-ssh'
    }

    options {
        timeout(time: 20, unit: 'MINUTES')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    docker build -t ${IMAGE_NAME} .
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh '''
                    echo "${DOCKER_PASSWORD}" | docker login -u ${DOCKER_USERNAME} --password-stdin
                    docker push ${IMAGE_NAME}
                    '''
                }
            }
        }

        stage('Deploy Docker Container on EC2') {
            steps {
                script {
                    echo "Deploying Docker Container on EC2"
                    echo "EC2 Host: ${EC2_HOST}"
                    withCredentials([file(credentialsId: "${SSH_KEY_ID}", variable: 'SSH_KEY')]) {
                        sh '''
                        ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} <<EOF
sudo docker stop ${CONTAINER_NAME} || true
sudo docker rm ${CONTAINER_NAME} || true
sudo docker pull ${IMAGE_NAME}
sudo docker run -d -p 3306:3306 --restart unless-stopped:/var/lib/mysql docker.io/mariadb
sudo docker run -d -p 8080:80 --restart unless-stopped docker.io/phpmyadmin
sudo docker run -d --name ${CONTAINER_NAME} -p 3000:3000 --restart unless-stopped ${IMAGE_NAME}
EOF
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Deployment succeeded!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
