pipeline {
  agent { label 'worker' }

  environment {
    IMAGE_NAME = "bohdan004/flask"
    TOKEN = credentials("botSecret")
    CHAT_ID = credentials("chatId")
  }

  stages {
    stage('Version Calculation') {
      steps {
        script {
          env.IMAGE_VERSION = sh(script: "git rev-parse --short=6 HEAD", returnStdout: true).trim()
        }
      }
    }
    stage("Build Docker Image") {
      steps {
        script {
          dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_VERSION}")
        }
      }
    }
    stage("Analyze Docker Image") {
      steps {
        script {
          sh "CI=true dive ${IMAGE_NAME}:${IMAGE_VERSION}"
        }
      }
    }
    stage("Push Docker Image") {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', 'DockerHub') {
            dockerImage.push("${IMAGE_VERSION}")
          }
        }
      }
    }
    stage('Update docker-compose.yml') {
      steps {
        script {
          def composeFile = readFile 'docker-compose.yml'
          composeFile = composeFile.replaceAll(/image: ${IMAGE_NAME}:\d+(\.\d+)?/, "image: ${IMAGE_NAME}:${IMAGE_VERSION}")
          writeFile file: 'docker-compose.yml', text: composeFile
        }
      }
    }
    stage('Deploy with Docker Compose') {
      steps {
        sh 'docker compose up -d --build'
      }
    }
    stage('Commit Changes') {
      steps {
        sh 'git config user.name "jenkins"'
        sh 'git config user.email "jenkins@panda.com"'
        sh 'git add docker-compose.yml'
        sh 'git commit -m "Update image version to ${IMAGE_VERSION}"'
        sh 'git push origin master'
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