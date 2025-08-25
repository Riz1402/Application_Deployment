pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = "dockerhub"
        DEV_REPO = "rizz1402/dev"
        PROD_REPO = "rizz1402/prod"
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
                        def IMAGE_TAG = "${DEV_REPO}:${COMMIT_HASH}"
                    } else if (env.BRANCH_NAME == "main") {
                        def IMAGE_TAG = "${PROD_REPO}:${COMMIT_HASH}"
                    } else {
                        error("This pipeline only runs for dev or main branches")
                    }
                }

                // Run build.sh
                sh "./build.sh"
            }
        }

        stage('Docker Login & Push') {
            steps {
                script {
                    sh """
                        echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                        docker tag App_Deployment:latest ${IMAGE_TAG}
                        docker push ${IMAGE_TAG}
                    """
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
                sh "./deploy.sh"
            }
        }
    }
}
