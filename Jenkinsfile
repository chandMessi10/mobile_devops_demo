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

/*
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
} */


pipeline {
    agent any
    stages {
        stage('Check FASTLANE_HOME') {
            steps {
                sh 'echo $FASTLANE_HOME'
            }
        }
    }
}