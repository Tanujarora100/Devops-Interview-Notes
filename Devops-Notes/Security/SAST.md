## **Static Application Security Testing (SAST)**



### **Benefits**
- **Early Detection**:
- **Comprehensive Code Analysis**: Analyzes the entire codebase
- **Integration with CI/CD**:

### **Challenges**
- **False Positives/Negatives**: SAST tools can produce false positives (incorrectly identifying non-issues as vulnerabilities) and false negatives (failing to identify actual vulnerabilities).
- **Scope Limitations**: SAST tools may not detect runtime errors, configuration issues, or
- **Time-Consuming**: Analyzing large codebases can be time-consuming.

### **Embedding SAST Tools into the Pipeline**
To embed SAST tools like FindBugs (now SpotBugs) into the CI/CD pipeline, follow these steps:
1. **Select a SAST Tool**: Choose a tool that supports your programming languages and integrates well with your CI/CD environment (e.g: SpotBugs for Java)[9].
2. **Configure the Tool**: Set up the SAST tool with appropriate rules and thresholds for your project.

### **Secrets Scanning**

#### **Tools for Secrets Scanning**
- **TruffleHog**: Scans git repositories for high-entropy strings and secrets.

### **Writing Custom Checks for Secrets Leakage**
To write custom checks for detecting secrets leakage:
1. **Identify Patterns**: Determine the patterns or regular expressions that match your organization's secrets (e.g., API key formats).
2. **Create Custom Rules**: Implement these patterns in your SAST or secrets scanning tool to detect and flag potential secrets.
