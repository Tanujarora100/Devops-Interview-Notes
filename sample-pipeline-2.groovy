pipeline {
    agent any
    parameters {
        string(name: 'issue_summary', defaultValue: '', description: 'Issue summary from the webhook')
        string(name: 'project_name', defaultValue: '', description: 'Project name from the webhook')
        string(name: 'issue_status', defaultValue: '', description: 'Issue status from the webhook')
        string(name: 'current_microservice', defaultValue: '', description: 'Current microservice pipeline to be triggered')
        string(name: 'current_jira_ticket', defaultValue: '', description: 'Current Jira ticket to be updated with logs') 
    }
    stages {
        stage('Print Webhook Data') {
            steps {
                script {
                    echo "Issue Summary: ${params.issue_summary}"
                    echo "Project Name: ${params.project_name}"
                    echo "Issue Status: ${params.issue_status}"
                    echo "Current MicroService to be triggered: ${params.current_microservice}"
                    echo "Jira Ticket ID: ${params.current_jira_ticket}"
                }
            }
        }
        stage('Trigger Microservice Pipeline') {
            steps {
                script {

                    def microservicePipelines = [
                        'PAYMENTS': 'microservice-one',
                        'SCADUI': 'microservice-two',
                        'LASTMILE': 'test-pipeline'
                    ]
                    
                    def pipelineName = microservicePipelines[params.current_microservice]
                    
                    if (pipelineName) {
                        echo "Triggering ${pipelineName} pipeline"
                        def additionalParams = [
                            string(name: 'jira_ticket', value: params.current_jira_ticket),
                            string(name: 'issue_summary', value: params.issue_summary),
                            string(name: 'project_name', value: params.project_name),
                            string(name: 'issue_status', value: params.issue_status)
                        ]
                        build job: pipelineName, parameters: additionalParams, wait: true
                    } else {
                        echo "No matching pipeline found for microservice: ${params.current_microservice}"
                    }
                }
            }
        }
        stage('Upload Logs to Jira') {
            steps {
                script {
                    def logFile = "${env.WORKSPACE}/build.log"
                    writeFile(file: logFile, text: currentBuild.rawBuild.getLog().join("\n"))
                    def response = uploadToJira(params.current_jira_ticket, logFile)
                    echo "Upload response: ${response}"
                }
            }
        }
    }
}


def uploadToJira(issueKey, filePath) {
    def jiraUrl = "https://tanujarora2703.atlassian.net"
    def uploadUrl = "${jiraUrl}/rest/api/2/issue/${issueKey}/attachments"
    def credentials = "your-username:your-api-token" 
    def authHeader = "Basic " + credentials.bytes.encodeBase64().toString()
    def response = httpRequest(
        url: uploadUrl,
        httpMode: 'POST',
        customHeaders: [[name: 'Authorization', value: authHeader], [name: 'X-Atlassian-Token', value: 'no-check']],
        requestBody: new File(filePath).bytes,
        validResponseCodes: '200:500'
    )
    return response
}
