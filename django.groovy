pipeline {
  agent any

  environment {
    IMAGE_NAME = "django-docker:1.1"
  }

  stages {
    stage("Build Docker Image") {
      steps {
        script {
            docker.build(IMAGE_NAME)
        }
      }
    }
    stage("Test Docker Image") {
      steps {
        echo "Test"
      }
    }
  }

  post {
    always {
      echo "Pipeline is done"
    }
  }
}