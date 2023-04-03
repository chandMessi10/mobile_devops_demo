#!/usr/bin/env groovy

/* pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
} */

/* pipeline {
  agent any

  stages {
    stage('Install Fastlane') {
      steps {
        sh 'gem install fastlane'
      }
    }
    // Add additional stages as needed
  }

  post {
    always {
      cleanWs()
    }
  }
} */

pipeline {
    agent any
    environment {
        FASTLANE_HOME = '/home/technerdy/var/lib/gems/3.0.0/gems/fastlane-2.212.1'
        PATH = "$PATH:$FASTLANE_HOME/bin"
    }
    stages {
        stage('Build') {
            steps {
                sh "fastlane deploy"
            }
        }
    }
}