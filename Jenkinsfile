#!/usr/bin/env groovy

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dir('android') {
                    sh 'fastlane deploy'
                }
            }
        }
    }
}