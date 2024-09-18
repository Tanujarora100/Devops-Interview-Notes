pipeline {
    agent any
    parameters {
        string(name: 'JIRA_TICKET_ID', defaultValue: '', description: 'Jira Ticket ID')
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Post Build') {
            steps {
                script {
                    def buildLog = currentBuild.rawBuild.getLog(50).join("\n")
                    def buildStatus = (currentBuild.result ?: 'SUCCESS') == 'SUCCESS' ? 'Build Passed' : 'Build Failed'
                    def customMessage = """
                    Jenkins Build Report:

                    - Build Status: ${buildStatus}
                    - Custom Message: The Jenkins pipeline has completed. Please review the logs below for details.
                    Build Logs:
                    ${buildLog}
                    """
                    jiraComment(issueKey: params.JIRA_TICKET_ID, comment: customMessage)
                }
            }
        }
    }
    post {
        always {
            script {
                def logFile = "${env.WORKSPACE}/build.log"
                writeFile(file: logFile, text: currentBuild.rawBuild.getLog().join("\n"))
                jiraAddAttachment(issueKey: params.JIRA_TICKET_ID, filePath: logFile)
            }
        }
    }
}
