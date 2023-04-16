#!/usr/bin/env groovy

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dir('android') {
                    sh 'chmod +x gradlew'
                    sh 'fastlane deploy'
                }
            }
        }
    }
}