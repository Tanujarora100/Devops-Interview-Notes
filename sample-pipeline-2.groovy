pipeline {
    agent any
     parameters {
        string(name: 'issue_summary', defaultValue: '', description: 'Issue summary from the webhook')
        string(name: 'project_name', defaultValue: '', description: 'Project name from the webhook')
        string(name: 'issue_status', defaultValue: '', description: 'Issue status from the webhook')
        string(name: 'current_microservice', defaultValue: '',description: 'Current microservice pipeline to be triggerred')
     }
    stages {
        stage('Print Webhook Data') {
            steps {
                script {
                    // Printing the extracted values from the webhook
                    echo "Issue Summary: ${params.issue_summary}"
                    echo "Project Name: ${params.project_name}"
                    echo "Issue Status: ${params.issue_status}"
                    echo "Current MicroService to be triggered : ${params.current_microservice}"
                }
            }
        }
        stage('Trigger Microservice Pipeline') {
            steps {
                script {
                    if (params.current_microservice == 'PAYMENTS') {
                        echo 'Triggering Microservice-One pipeline'
                        // Trigger Microservice-One job
                        build job: 'microservice-one', wait: false
                    } else if (params.current_microservice == 'SCADUI') {
                        echo 'Triggering Microservice-Two pipeline'
                        // Trigger Microservice-Two job
                        build job: 'test-pipeline', wait: false
                    } else {
                        echo 'No matching microservice found for value: ${params.current_microservice}'
                    }
                }
            }
        }
    }
}
