#!/usr/bin/env groovy

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dir('android') {
                    sh 'chmod 777 gradlew'
                    sh 'fastlane deploy'
                }
            }
        }
    }
}