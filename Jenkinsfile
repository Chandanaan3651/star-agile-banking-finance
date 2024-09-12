pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven"
    }

    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/Chandanaan3651/star-agile-banking-finance.git'

                // Run Maven on a Unix agent.
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
                }        
            }
        stage('Generate Test Reports') {
           steps {
               publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/FinanceMe/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                    }
            }
        stage('Create Docker Image') {
           steps {
               sh 'docker build -t chandana3651/finance-me:1.0 .'
                    }
            }
        stage('Docker-Login') {
           steps {
               withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'dockerpassword', usernameVariable: 'dockerhub')]) {
               sh 'docker login -u ${dockerhub} -p ${dockerpassword}'
                             }
                    }
            }
        stage('Push-Image') {
           steps {
               sh 'docker push chandana3651/finance-me:1.0'
                    }
            }
        stage('Config & Deployment') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWSAccessKey', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir('terraform-files') {
                    sh 'sudo chmod 600 key-ohio.pem'
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
    }
}
