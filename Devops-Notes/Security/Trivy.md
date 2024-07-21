## Trivy Interview Questions

1. **What is Trivy?**
   - open-source security scanner
   - By Aqua Security
2. **Trivy Severity**:
   - Critical
   - High 
   - Low
3. **Securing Images**
   - Distroless images
   - Trivy Tool
   - Multi Stage Build
   - Non root user 
   
2. **What types of vulnerabilities can Trivy detect?**
     - OS package vulnerabilities (e.g., Alpine, RHEL, CentOS)
     - Application dependencies vulnerabilities
     - (IaC) misconfigurations

4. **How does Trivy work?**
   - comparing the software packages against a vulnerability database.

5. **What is the Trivy database, and how is it updated?**
   - internal database called `trivy-db`.
   - updated every 6 hours automatically

5. **How can Trivy be integrated into a CI/CD pipeline?**
     ```groovy
     pipeline {
       agent any
       stages {
         stage('Build') {
           steps {
             sh 'docker build -t myapp:latest .'
           }
         }
         stage('Scan') {
           steps {
             sh 'trivy image myapp:latest'
           }
         }
       }
     }
     ```

6. **Explain how to use Trivy to scan a Docker image.**
     For example, to scan the `nginx:latest` image:
     ```sh
     trivy image nginx:latest
     ```

9. **How would you handle false positives in Trivy scan results?**
   - False positives can be managed by:
     - Using the `.trivyignore` file to exclude specific vulnerabilities.
     - Providing feedback to the Trivy maintainers.


## How to Generate Trivy Reports in Specific Formats
- Table format default

    ```sh
    trivy image -f json -o results.json golang:1.12-alpine
    ```
- Custom Templates
    ```sh
    trivy image --format template --template "{{ range . }} {{ .Target }} {{ end }}" golang:1.12-alpine
    ```
-  **Convert JSON to HTML**
    ```sh
    trivy convert --format template --template @/path/to/template -o report.html results.json
    ```