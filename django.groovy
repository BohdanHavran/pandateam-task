pipeline {
    agent { label 'worker' }

    environment {
        IMAGE_NAME = "django-docker:1.1"
        TOKEN = credentials("botSecret")
        CHAT_ID = credentials("chatId")
    }

    stages {
        stage("Verify Docker Access") {
            steps {
                sh "docker ps"
            }
        }
        stage("Build Docker Image") {
            steps {
                script {
                    def dockerImage = docker.build("${IMAGE_NAME}", ".")
                }
            }
        }
        stage("Test Docker Image") {
            steps {
                whoami
            }
        }
    }

    post {
        success { 
            sh ("""
                curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*Full project name*: ${env.JOB_NAME} \n*Branch*: [$GIT_BRANCH]($GIT_URL) \n*Build* : [OK](${BUILD_URL}consoleFull)'
            """)
        }
        aborted {
            sh ("""
                curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*Full project name*: ${env.JOB_NAME} \n*Branch*: [$GIT_BRANCH]($GIT_URL) \n*Build* : [Aborted](${BUILD_URL}consoleFull)'
            """)
        }
        failure {
            sh ("""
                curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='*Full project name*: ${env.JOB_NAME} \n*Branch*: [$GIT_BRANCH]($GIT_URL) \n*Build* : [Not OK](${BUILD_URL}consoleFull)'
            """)
        }
    }
}
