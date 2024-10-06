## Intro

- **AWS managed CD server** to automatically deploy the latest version of the application.
- To use CodeDeploy, we first need to create an Application (in CodeDeploy console) with the correct compute platform configured. Then, create a `Deployment Group` with the compute resource tagged. Then, we can create a deployment with the correct application build artifact.

## Components

- Application - the build artifact (archived) we want to deploy
- **Compute Platform** - what platform the application will be deployed to
    - EC2 or On-Premises (**CodeDeploy Agent** must be installed)
    - AWS Lambda
    - Amazon ECS
    - Amazon EKS
        - Deployment Agent: You’ll also need the CodeDeploy agent running on the worker nodes of your EKS cluster to ensure the rollout process can be managed by CodeDeploy.
- Deployment Configuration - set of deployment rules for successful deployment
    - EC2/On-premises - specify the minimum number of healthy instances for the deployment
    - AWS Lambda or Amazon ECS - specify how traffic is routed to your updated versions
- **Deployment Group** - group of tagged EC2 instances (allows to deploy gradually, ex: first deploy to `dev`, then `test` and then `prod`)
- **IAM Instance Profile** - give EC2 instances the `permissions to access S3 or GitHub`
- **Application Revision** = build artifact + `appspec.yaml` file
- **Service Role** - IAM Role for CodeDeploy to perform operations on EC2 instances, ASGs, ELBs for deployment
- Target Revision - the most recent revision that you want to deploy to a Deployment Group