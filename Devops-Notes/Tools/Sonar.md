## SonarQube Interview Questions


1. **What is SonarQube?**
   - open-source platform developed by SonarSource
    - It performs automated reviews of code to detect bugs, security vulnerabilities.
2. **Explain why SonarQube needs a database.**
   - SonarQube uses a database to store the results of code analysis. This includes issues, metrics, and historical data.

5. **What is a code smell in SonarQube?**
   - A code smell is a violation of good coding practices.

6. **How does SonarQube calculate code coverage?**
   - SonarQube calculates code coverage by analyzing the results of unit tests.

7. **What is a quality gate in SonarQube?**
   - A quality gate is a set of conditions that a project must meet to be considered of acceptable quality.

8. **What are Quality Profiles in SonarQube?**
   - Quality Profiles are sets of rules that define the coding standards for a project. 

9. **How can you create reports in SonarQube?**
    - You can create reports in SonarQube using Maven commands. For example:
      ```bash
      mvn clean install
      mvn sonar:sonar -Dsonar.issuesreport.html.enable=true
      ```
10. **What is the role of SonarLint?**
    - IDE extension that provides on-the-fly feedback to developers on new bugs and quality issues.
11. **How would you handle false positives in SonarQube analysis?**
    - Marking issues as "False Positive" in the SonarQube dashboard.
    - Customizing the quality profile