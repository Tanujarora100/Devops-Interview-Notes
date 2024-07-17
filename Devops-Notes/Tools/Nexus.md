
### What is Sonatype Nexus, and why is it used?
- helps store, manage, and distribute software components and dependencies. 

### Name some popular package formats supported 
- such as Maven, npm, NuGet

### Explain the concept of a repository proxy.
- A repository proxy in Nexus serves as a cache for remote repositories.

### What are repository groups, and why are they useful?
- Repository groups combine multiple repositories into a single virtual repository. 


### What are the steps to install Nexus Repository Manager?
 
For Docker, you can use the command 
`docker run -d -p 8081:8081 --name nexus -v /some/dir/nexus-data:/nexus-data sonatype/nexus3.

### How can you change the default port that Nexus listens on?
- Modify the `nexus.properties` file located in the `etc` directory of the Nexus installation and change the `application-port` property

### Explain how you would perform a backup and restore of Nexus configurations and repositories
- Regularly back up the `nexus-data` directory and relevant configuration files. 


### How can you ensure efficient artifact search and retrieval in Nexus?
- Use Nexus  `search functionality `and organize artifacts with appropriate naming and versioning conventions.

### Explain the difference between a hosted repository and a proxy repository in Nexus.

- A hosted repository is a local repository hosted on the Nexus server where you can upload and manage your artifacts. 
- A proxy repository acts as a `caching proxy for a remote repository`, fetching artifacts from external sources and storing them locally to improve performance and availability.

### What is Nexus Smart Proxy and how does it enhance performance?
- Nexus Smart Proxy extends repository proxies to remote locations, `providing local caching and faster access to artifacts` for geographically distributed teams.

#### You encounter a situation where a proxy repository is not syncing artifacts. How would you troubleshoot this issue.
- Check the network connectivity between Nexus and the remote repository.
- Verify the remote repository URL and credentials.
- Review the Nexus logs.
- Clear the proxy cache and attempt to sync again.

### What strategies would you use for managing large numbers of artifacts in Nexus?
- Implementing cleanup policies.
- Monitoring repository usage 
- Archiving older artifacts.

### What is the difference between Nexus OSS (Open Source) and Nexus Pro (Professional)?
- Nexus OSS is the free, open-source version
- Nexus Pro for staging and LDAP Integration.

### Describe a scenario where you would use a raw repository in Nexus.
- A raw repository in Nexus is used to store and manage any type of file that does not fit into the predefined repository formats (e.g., Maven, npm). 
- A common scenario for using a raw repository is when you need to store binary files, configuration files.

### How can you secure access to repositories in Nexus?
- Create roles and assign permissions 
- Create users and assign them the appropriate roles.
- Use SSL/TLS to encrypt communication 
- Zero Trust Policy
- Least Privileged Access
- Enable and configure authentication mechanisms like LDAP, SAML.
