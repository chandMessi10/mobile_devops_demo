#!/usr/bin/env groovy

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'cd android'
                sh 'cd fastlane'
                sh 'fastlane deploy'
            }
        }
    }
}