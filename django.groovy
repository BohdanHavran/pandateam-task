pipeline {
  agent any

  stages {
    stage("Hello") {
      steps {
        echo "hello"
      }
    }
  }

  post {
    always {
      echo "Pipeline is done"
    }
  }
}