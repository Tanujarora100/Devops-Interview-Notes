pipeline {
    agent any

    environment {
        JIRA_URL = 'https://tanujarora2703.atlassian.net'  // Your Jira instance URL
        JIRA_USER = credentials('JIRA_USER')               // Username stored in Jenkins credentials
        JIRA_API_TOKEN = credentials('JIRA_API_TOKEN')     // API Token stored in Jenkins credentials
    }

    parameters {
        string(name: 'WEBHOOK_PAYLOAD', defaultValue: '', description: 'Payload from Webhook')
    }

    stages {
        stage('Extract Issue Key') {
            steps {
                script {
                    // Assuming the payload has a field "issue_key" containing the Jira issue key
                    def payload = readJSON text: "${params.WEBHOOK_PAYLOAD}"
                    env.JIRA_ISSUE_KEY = payload.issue.key // Modify based on actual payload structure
                }
            }
        }

        stage('Build') {
            steps {
                // Your build steps here
            }
        }

        stage('Post to Jira') {
            steps {
                script {
                    def buildUrl = "${env.BUILD_URL}" // Jenkins build URL
                    def buildLogs = currentBuild.rawBuild.getLog(100) // Retrieve build logs

                    // Jira API URL for updating the ticket
                    def jiraApiUrl = "${JIRA_URL}/rest/api/2/issue/${env.JIRA_ISSUE_KEY}/comment"
                    
                    def comment = """{
                        "body": "Build URL: ${buildUrl}\n\nLogs:\n${buildLogs}"
                    }"""

                    httpRequest(
                        url: jiraApiUrl,
                        httpMode: 'POST',
                        contentType: 'APPLICATION_JSON',
                        customHeaders: [
                            [name: 'Authorization', value: "Basic ${Base64.encoder.encodeToString("${JIRA_USER}:${JIRA_API_TOKEN}".getBytes())}"]
                        ],
                        requestBody: comment
                    )
                }
            }
        }
    }
}
