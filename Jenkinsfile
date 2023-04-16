#!/usr/bin/env groovy

pipeline {
    agent any

    node {
        stage("Build") {
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