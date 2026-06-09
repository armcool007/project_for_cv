pipeline {
    agent any
    environment {
        scanner_home=tool 'sonarqube'
    }

    stages {
        stage('gitclone') {
            steps {
                git branch: 'main', url: 'https://github.com/armcool007/project_for_cv.git'
            }
        }
        stage('sonarqube'){
            steps{
                withSonarQubeEnv('sonarqube') {
                    sh '$scanner_home/bin/sonar-scanner -Dsonar.projectName=cv1 -Dsonar.projectKey=cv1'
                }
            }
        }
        
        stage('trivy scan'){
            steps{
                sh 'trivy fs . > cv1_img_scan.txt'
            }
        }
        stage('docker build'){
                steps{
                    sh 'docker build -t armcool004/project_maven .'
                }
        }
        //stage('trivy docker image scan') {
        //    steps{
         //       sh 'trivy image armcool004/project_maven > cv1_docker_scan.txt'
          //  }
    //    }
        stage('docker push'){
            steps{
                withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
                    sh 'docker push armcool004/project_maven'
                }
            }
        }
        stage('docker run'){
            steps{
                sh 'docker run -dit --name cv1 -p 8081:8080 armcool004/project_maven'
            }
        }
        stage('save artifact in s3'){
            steps {
                s3Upload(
                    profileName: 'jenkins_s3_role',
                    entries: [[
                        sourceFile: '**/*',
                        bucket: 'outoftheworld9',
                        selectedRegion: 'ap-south-1'
                    ]],
                        pluginFailureResultConstraint: 'FAILURE',
                        consoleLogLevel: 'INFO',
                        dontWaitForConcurrentBuildCompletion: false,
                        dontSetBuildResultOnFailure: false,
                        userMetadata: []
                )
            }
        }
    }
}
