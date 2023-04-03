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
    stages {
//         stage('Setup') {
//             steps {
//                 echo "Setup"
//                 // Install bundler in order to use fastlane
//                 sh "gem install bundler"
//                 // set the local path for bundles in vendor/bundle
//                 sh "bundle config set --local path 'vendor/bundle'"
//                 // install bundles if they're not installed
//                 sh "bundle check || bundle install --jobs=4 --retry=3"
//             }
//         }
        stage('Build') {
            steps {
                echo "Building for App distribution"
                sh "bundle exec fastlane deploy"
            }
        }
    }
}