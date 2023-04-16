#!/usr/bin/env groovy

pipeline {
    agent any

    stages {
        stage('Build') {
            sh script:'''
                      #!/bin/bash
                      cd ./android
                      echo "inside android"
                      cd ./fastlane
                      echo "inside fastlane"

            '''
        }
    }
}