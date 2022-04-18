pipeline {
    agent any
    
    parameters { 
        booleanParam(name: 'Apply', defaultValue: true) 
        booleanParam(name: 'Destroy', defaultValue: false) 
    }
    
    environment {
        AWS_ACCESS_KEY_ID        = credentials('TF_AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY    = credentials('TF_AWS_SECRET_ACCESS_KEY')
        SETTINGS_MAVEN           = credentials('settings_maven')
        SECURITY_SETTINGS_MAVEN  = credentials('security_settings_maven')
        TF_VAR_nexus_url         = "http://130.162.35.117:8081"
    }
    
    stages {
        stage('Git clone'){
            steps{
                git url: 'http://github.com/eugenia-ponomarenko/SSITA-GeoCitizen-AWS.git', credentialsId: 'github', branch: 'lb_asg'
            }
         }
        
        stage('Copy email credentials') {
            steps {
              sh "sudo cp \$SETTINGS_MAVEN /var/lib/jenkins/.m2/"
              sh "sudo cp \$SECURITY_SETTINGS_MAVEN /var/lib/jenkins/.m2/"
              sh "sudo chmod 755 /var/lib/jenkins/.m2/settings.xml"
            }
        }
        
        stage('Terraform init LB and RDS') {
            steps {
                sh "cd Terraform/lb_rds/; terraform init"
            }
        }
        
        stage('Terraform apply LB and RDS'){
            when {
                expression { params.Apply == true }
            }
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId:'psqlCreds',
                 usernameVariable: 'TF_VAR_psql_username', passwordVariable: 'TF_VAR_psql_password']]){                
                    sh "cd Terraform/lb_rds/; terraform apply --auto-approve -no-color"
                }           
            }
        }
        
        stage('Change email credentials in application.properties'){
            steps{
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId:'emailCredentials',
                 usernameVariable: 'email_login', passwordVariable: 'email_password']]){
                    script {
                        sh '''#!/bin/bash
                        email=${email_login}
                        password=${email_password}
                        sed -i "s/[a-z0-9.]\\{5,\\}@gmail\\.com/$email/g" ./src/main/resources/application.properties
                        sed -i "s/email.password=[A-Za-z0-9!@#$%^&*-]\\{8,32\\}/email.password=$password/g" ./src/main/resources/application.properties
                        
                        . ./Terraform/hosts.sh
                    
                        #----------------------------------------------------------------------------------------------------
                        # Fix application.properties
                        sed -i -E \\
                                    "s/(http:\\/\\/localhost:8080)/http:\\/\\/$lb_dns:80/g; \\
                                    s/(postgresql:\\/\\/localhost:5432)/postgresql:\\/\\/$db_host/g;
                                    s/(35.204.28.238:5432)/$db_host/g; " src/main/resources/application.properties
                        
                        #----------------------------------------------------------------------------------------------------
                        # Repair index.html favicon
                        sed -i "s/\\/src\\/assets/\\.\\/static/g" src/main/webapp/index.html
                        
                        #----------------------------------------------------------------------------------------------------
                        # Repair js bundles
                        find ./src/main/webapp/static/js/ -type f -exec sed -i "s/localhost:8080/$lb_dns:80/g" {} +
                        find ./src/main/webapp/static/js/ -type f -exec sed -i "s/localhost/$lb_dns/g" {} +
                        '''
                    }
                }
            }
        }
        
        stage('Update IP address for Nexus'){
            when {
                expression { params.Destroy == false }
            }
            steps{
                sh 'sudo sed -i "s/192.168.1.125:8081/10.0.0.124:8081/g" ./pom.xml'
            }
        }
        
        stage('Deploy citizen.war to Nexus'){
            when {
                expression { params.Apply == true }
            }
            steps{
                sh "mvn deploy"
            }
        }  
        
        stage('Terraform init ASG') {
            steps{
                sh "cd Terraform/asg/; terraform init"
            }
        }
        
        stage('Terraform apply ASG') {
            when {
                expression { params.Apply == true }
            }
            steps{
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId:'nexus',
                 usernameVariable: 'TF_VAR_nexus_user', passwordVariable: 'TF_VAR_nexus_password']]){  
                    sh "cd Terraform/asg/; terraform apply --auto-approve -no-color"
                }
            }
        }

        stage('Terraform destroy ASG'){
            when {
                expression { params.Destroy == true }
            }
            steps{
                sh "cd Terraform/asg/; terraform destroy --auto-approve -no-color"
            }
        }
        
        stage('Terraform destroy LB and RDS'){
            when {
                expression { params.Destroy == true }
            }
            steps{
                sh "cd Terraform/lb_rds/; terraform destroy --auto-approve -no-color"
            }
        }
    } 
        post {
       success {
           slackSend(channel: 'geocitizen', color: 'good', message: "Build success  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
       }
       failure {
           slackSend(channel: 'geocitizen', color: 'RED', message: "Build failed  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
       }
    }
}
