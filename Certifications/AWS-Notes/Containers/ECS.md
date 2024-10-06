## Secrets in ECS tasks

- Store the secrets in Secrets Manager or Parameter Store and encrypt them using KMS
- Reference the secrets in container definition with the name of the environment variable
- Create an **ECS task execution role** and reference it with your task definition, which allows access to both KMS and the Parameter Store/Secrets Manager.
- Supported for both EC2 and Fargate launch types

## Bind Mounts

- **Shared volume between multiple containers** running the same application (same definition file).
- Bind mount lifecycle
    - EC2 Tasks: lifecycle of EC2 instances since the volumes exist on the host
    - Fargate Tasks: lifecycle of the ECS task [20 GiB (default) - 200 GiB]

## Shared File System in ECS

- **EFS can be mounted as a shared file system between ECS tasks**
- Works for both EC2 and Fargate launch types
- ECS Fargate + EFS ⇒ serverless

## ECS Service Auto Scaling

- Auto scale the number of ECS tasks in a service
- **AWS Application Auto Scaling** can be used to scale on metrics:
    - ECS Service Average CPU Utilization
    - ECS Service Average Memory Utilization
    - ALB Request Count Per Target
- The above metrics can be used to setup target tracking or step scaling for ECS tasks. Scheduled scaling can also be used.
- Easier to setup on Fargate launch type because we don’t have to scale the underlying resource.
- For EC2 launch type, auto-scaling EC2 instances:
    - Using ASG to scale out based on CPU utilization
    - **ECS Cluster Capacity Provider** - automatically scales out EC2 instances when the service is missing capacity.

## Task Definition

- Analogous to Docker Compose
- Tells ECS how to run the docker containers
- **Only 1 IAM Role can be defined per Task Definition.** All the tasks within a service will assume that role.
- Environment variables in Task Definitions
    - Hardcoded (defined in the task definition file)
    - Referenced from Parameter Store
    - Referenced from Secrets Manager
    - Imported as Environment Files from S3 bucket

## Task Placement

This is to be decided only in EC2 launch type. 

### Task Placement Strategy

- **Binpack**
    - Fill up an instance (in terms of CPU or memory) and only then provision a new instance.
    - Minimize cost (number of instances)
    - Example: Binpack on memory

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/a62a7f33-1546-4c58-8ddd-1ea3a991abac/87a49d11-3283-4f5d-84e3-e8a42eaa173e/Untitled.png)

- **Random**
    - Randomly select an instance to place the task.

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/a62a7f33-1546-4c58-8ddd-1ea3a991abac/bb64f398-3a32-4fea-809b-26fdfa29843f/Untitled.png)

- **Spread**
    - Spread the tasks on a parameter
    - Maximize availability
    - Example: spread on AZ

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/a62a7f33-1546-4c58-8ddd-1ea3a991abac/8dfe1499-16e2-4ce6-a060-f1d28d97021f/Untitled.png)

- Task placement strategy can be mixed such as spread on AZ and binpack on memory:

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/a62a7f33-1546-4c58-8ddd-1ea3a991abac/6e8b69dc-8412-422a-afc2-208768c6174c/Untitled.png)

### Task Placement Constraints

- `distinctInstance` - place each task on a different instance
- `memberOf` - place task on instances that satisfy an expression (eg. only on T2 family of instances)

## Troubleshooting Steps

- Verify that the Docker daemon is running on the container instance.
- Verify that the container agent is running on the container instance.
- Verify that the IAM instance profile has the necessary permissions.

## Misc

- You can use EventBridge to run Amazon ECS tasks when certain AWS events occur. Ex: set up a CloudWatch Events rule that runs an Amazon ECS task whenever a file is uploaded to an S3 bucket.
- For tracing, create a Docker image that runs the X-Ray daemon, upload it to a Docker image repository, and then deploy it to your Amazon ECS cluster. Configure the task definition file to allow your application to communicate with the daemon container.
- Use **advanced container definition parameters** to define environment variables for a task.