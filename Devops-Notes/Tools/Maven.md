#### What is Maven?
- Open source tool by apache
- Uses Project Object Model(POM)

#### What does Maven help with?
- Managing project builds
- dependencies
- Generating documentation
- Reporting

#### What is POM in Maven?
- Project Object Model. 
- It is an XML file.

#### What are the different types of repositories in Maven?
- Local Repository: 
- Central Repository: MVN Repository
- Remote Repository: Hosted by third parties and can be configured in the POM file like Nexus.


#### What is a Maven Build Lifecycle?
- Default: Handles project deployment.
- Clean: Handles project cleaning.
- Site: Create Project Documentation

#### What are the phases of the Maven Build Lifecycle?
- Validate
- Compile
- Test
- Package
- Integration-test
- Verify
- Install
- Deploy

#### What is a Maven Artifact?
- A Maven Artifact is a file, usually a JAR
Each artifact is identified by a group ID, an artifact ID, and a version string

#### What is Maven Group ID?
- Reverse Domain Name: The groupId should start with a reversed domain name you control. 
    - For example, org.apache for projects under the Apache Software Foundation.
- Consistency: 


#### Name the three built-in build lifecycles in Maven.
- build lifecycles are default, clean, and site.
correct and all necessary information is available.

#### Explain the compile phase in Maven.
- The compile phase compiles the source code of the project.

#### What happens in the test phase?
- The test phase runs the tests using a suitable unit testing framework, like JUnit.

#### What is the package phase in Maven?
- The package phase takes the compiled code and packages it into its distributable format, such as a JAR or WAR file.

#### What is the role of the install phase?
- The install phase installs the package into the local repository for use as a dependency in other projects locally.

#### How can you skip tests in Maven?
- Use the -DskipTests or -Dmaven.test.skip=true flag to skip tests during the build process.
- mvn install -DskipTests


#### What are Maven Plugins and their types?
Maven plugins are used to extend the functionality of Maven. They are categorized into:
- Build Plugins: Used during the build process (e.g., Compiler Plugin).
- Reporting Plugins: Used to generate reports (e.g., Surefire Plugin)


#### What is the profile element in Maven?**
- The profile element in Maven allows you to customize the build for different environments. 

#### What is Dependency Exclusion in Maven?**
- Dependency Exclusion is a mechanism to exclude specific transitive dependencies from the project. 
- This is useful when there are conflicts or compatibility issues with dependencies. It is done using the `<exclusions>` tag within the dependency declaration in the POM file.

#### How does Maven handle transitive dependencies?**
- Maven automatically includes transitive dependencies, which are dependencies of your project's dependencies.
- This helps in managing complex dependency trees but can also lead to conflicts, which can be resolved using dependency exclusions or specifying versions explicitly


#### How do you enforce coding standards in a Maven project?
- Use plugins like maven-checkstyle-plugin or maven-pmd- plugin to enforce coding standards.

#### What is the recommended directory structure for a Maven project?
- The standard directory structure includes src/main/java, src/main/resources, src/test/java, and src/test/resources.

#### How do you manage multi-module dependencies?
- Define dependencies in the parent POM's dependencyManagement section and reference them in the child modules.

#### Why should you avoid using SNAPSHOT versions in production?
- SNAPSHOT versions are unstable and can change frequently, leading to inconsistent builds.

#### How do you handle large dependency trees in Maven?
- Use the maven-dependency-plugin to analyze and visualize dependencies

What are the advantages of using a BOM?
Answer: A BOM ensures consistent dependency versions across multiple
projects, reducing conflicts and simplifying dependency management.


#### How do you resolve version conflicts in Maven?
- Use the maven-dependency-plugin to identify and resolve version conflicts

#### How do you handle "Out of Memory" errors in Maven?
- Increase the memory available to Maven by setting the MAVEN_OPTS environment variable.
```bash
export MAVEN_OPTS=" -Xmx1024m -XX:MaxPermSize=256m"
```
#### What is the dependency:tree goal used for?
- The dependency:tree goal displays the dependency tree of the project.



#### How do you debug a failing Maven build?
Use the -X flag to enable debug output
``` bash
mvn install -X
```

#### How do you handle "Checksum failed" errors in Maven?
- Delete the corrupt dependency from the local repository and re-run the build to download it again.
```bash
rm -rf ~/.m2/repository/com/example/dependency
mvn install
```

#### How do you force Maven to update snapshots?
- Use the -U flag to force Maven to update snapshots.
```sh
mvn install -U
```
#### How do you configure a plugin in Maven?
Answer: Plugins are configured in the <build> section of the POM file.
```xml
<build>
<plugins>
<plugin>
<groupId>org.apache.maven.plugins</groupId>
<artifactId>maven-compiler-plugin</artifactId>
<version>3.8.0</version>
<configuration>
<source>1.8</source>
<target>1.8</target>
</configuration>
</plugin>
</plugins>
</build>
```

#### What is the maven-release-plugin?
- The maven-release-plugin helps in automating the release
process of a project, including updating version numbers and tagging the project in SCM.

#### What is the maven-enforcer-plugin used for?
- The maven-enforcer-plugin is used to enforce rules, such as requiring specific versions of Maven, Java.


#### ow do you configure a remote repository in Maven?
<repositories> section of the POM file.
```xml
<repositories>
<repository>
<id>my-repo</id>
<url>http://example.com/maven2</url>
</repository>
</repositories>
```

#### What is the settings.xml file in Maven?
- The settings.xml file is used to configure user-specific settings, such as repository credentials and proxy settings. 
- It is located in the .m2 directory.


#### How do you configure proxy settings in Maven?
```xml
<proxies>
<proxy>
<id>example-proxy</id>
<active>true</active>
<protocol>http</protocol>
<host>proxy.example.com</host>
<port>8080</port>
<username>user</username>
<password>password</password>
</proxy>
</proxies>
```
#### How do you mirror repositories in Maven?
- Repositories can be mirrored by configuring the mirrors section in the `settings.xml` file.
```xml
<mirrors>
<mirror>
<id>central</id>
<mirrorOf>central</mirrorOf>
<url>http://mirror.example.com/maven2</url>
</mirror>
</mirrors>
```
