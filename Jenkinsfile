pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = "dockerhub"
        DEV_REPO = "rizz1402/dev"
        PROD_REPO = "rizz1402/prod"
        IMAGE_TAG = ""   // will be set dynamically
    }

    triggers {
        githubPush()   // Auto trigger when code is pushed to GitHub
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                script {
                    def COMMIT_HASH = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()

                    if (env.BRANCH_NAME == "dev") {
                        env.IMAGE_TAG = "${env.DEV_REPO}:${COMMIT_HASH}"
                    } else if (env.BRANCH_NAME == "main") {
                        env.IMAGE_TAG = "${env.PROD_REPO}:${COMMIT_HASH}"
                    } else {
                        error("This pipeline only runs for dev or main branches")
                    }
                }

                // Run build.sh
                sh 'chmod +x build.sh'
                sh "./build.sh"
            }
        }

        stage('Docker Login & Push') {
    steps {
        script {
            withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                sh """
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker tag app_deployment:latest ${IMAGE_TAG}
                    docker push ${IMAGE_TAG}
                """
            }
        }
    }
}

        stage('Deploy') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'main'
                }
            }
            steps {
                // Run deploy.sh
                sh 'chmod +x deploy.sh'
                sh "./deploy.sh ${IMAGE_TAG}"
            }
        }
    }
}
