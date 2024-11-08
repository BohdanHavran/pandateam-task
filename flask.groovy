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
          composeFile = composeFile.replaceAll(/image: ${IMAGE_NAME}:.*/, "image: ${IMAGE_NAME}:${IMAGE_VERSION}")
          writeFile file: 'docker-compose.yml', text: composeFile
        }
      }
    }
    stage('Deploy with Docker Compose') {
      steps {
        sh 'docker compose up -d --build'
      }
    }
    stage('Test Application') {
      steps {
        script {
          def response = sh(script: "curl -s -o /dev/null -w '%{http_code}' https://flask.dns.army/health", returnStdout: true).trim()
          if (response != '200') {
            error("Test failed. Expected HTTP 200, but got ${response}")
          }
        }
      }
    }
  }

  post {
    success { 
      script {
        def duration = currentBuild.durationString ?: "Duration not available"
        sh ("""
          curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='✅ *Project*: ${env.JOB_NAME} \n🌿 *Branch*: [$GIT_BRANCH]($GIT_URL) \n🚀 *Status*: [Success](${BUILD_URL}consoleFull) \n⏰ *Duration*: ${duration} \n👤 *Triggered by*: ${env.BUILD_USER}'
        """)
      }
    }
    aborted {
      script {
        def duration = currentBuild.durationString ?: "Duration not available"
        sh ("""
          curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='⚠️ *Project*: ${env.JOB_NAME} \n🌿 *Branch*: [$GIT_BRANCH]($GIT_URL) \n🚧 *Status*: [Aborted](${BUILD_URL}consoleFull) \n⏰ *Duration*: ${duration} \n👤 *Triggered by*: ${env.BUILD_USER}'
        """)
      }
    }
    failure {
      script {
        def duration = currentBuild.durationString ?: "Duration not available"
        sh ("""
          curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode=markdown -d text='❌ *Project*: ${env.JOB_NAME} \n🌿 *Branch*: [$GIT_BRANCH]($GIT_URL) \n💥 *Status*: [Failed](${BUILD_URL}consoleFull) \n⏰ *Duration*: ${duration} \n👤 *Triggered by*: ${env.BUILD_USER}'
        """)
      }
    }
  }
}