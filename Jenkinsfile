#!/usr/bin/env groovy

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'cd ./android'
                sh 'bundle exec fastlane deploy'
            }
        }
    }
}