pipelineJob('flask') {
  definition {
    cpsScm {
      scm {
        git {
          remote {
            github('BohdanHavran/pandateam-task')
          }
          branch('*/master')
        }
      }
      scriptPath('flask.groovy')
    }
  }
  triggers {
    githubPush()
  }
}

job('restart container flask-app') {
  steps {
    shell('docker restart flask-app')
  }
}