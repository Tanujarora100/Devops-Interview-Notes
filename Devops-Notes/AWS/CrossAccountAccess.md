## How Cross-Account Access Works with IAM Roles and EC2 Instances

When you attach an IAM role to an EC2 instance, it allows the instance to assume the role and access resources in other AWS accounts. Here's how it works:

1. **You create an IAM role** in the destination account that has the necessary permissions to access resources in that account. For example, the role might have permissions to read from an S3 bucket.

2. **You attach the IAM role** to an EC2 instance in the originating account. 
- This establishes a trust relationship between the instance and the role.

3. **When the application running on the EC2 instance needs to access resources** in the destination account, it makes API calls using the instance profile associated with the role.

4. **AWS STS (Security Token Service) generates temporary security credentials** for the role, including an access key ID, secret access key, and session token. These are known as "assumed role" credentials.

5. **The EC2 instance uses these temporary credentials** to sign API requests and access resources in the destination account that the role has permissions for.

6. **The temporary credentials are valid for a specified duration** (up to 1 hour by default). When they expire, the instance can request new credentials by assuming the role again.

7. **The application never has access to the actual long-term credentials** for the IAM role. It only uses the short-lived assumed role credentials.

This allows the EC2 instance to securely access resources in other accounts without needing to store or manage any long-term credentials. The IAM role acts as a secure proxy for cross-account access.
## INSTANCE PROFILE:
An instance profile in AWS is a container for an IAM (Identity and Access Management) role that allows you to pass role information to an Amazon EC2 instance when it starts. 

### Definition and Purpose

- **Container for IAM Role**: An instance profile serves as a wrapper around an IAM role. When you launch an EC2 instance, you can associate it with an instance profile, which allows the instance to assume the permissions defined in the IAM role.

- **Passing Role Information**: The primary purpose of an instance profile is to enable EC2 instances to obtain temporary security credentials that grant them permissions to access other AWS resources based on the policies attached to the associated IAM role.

### Creation and Usage

- **Automatic Creation**: When you create an IAM role for EC2, AWS automatically creates an instance profile with the same name as the role. 
- This instance profile can then be attached to EC2 instances.

- **Single Role Association**: An instance profile can only contain one IAM role, but multiple instances can use the same instance profile to assume the same role.

### Trust Relationship

- **Trust Policy**: The instance profile must specify that EC2 is a trusted entity in its trust policy. 
- This allows EC2 instances to assume the role contained within the instance profile, enabling them to perform actions defined by the role's permissions.

### Temporary Credentials

- **Assuming the Role**: When an EC2 instance starts, it uses the instance profile to assume the IAM role. 
- AWS Security Token Service (STS) generates temporary security credentials for this role, which the instance can use to access AWS resources.
To assign an IAM role to an instance profile in AWS, you can follow these steps using the AWS Management Console or the AWS CLI. Here’s how to do it through both methods:

### Using the AWS Management Console

1. **Create an IAM Role**:
   - Go to the IAM console.
   - Click on "Roles" and then "Create role."
   - Choose the type of trusted entity (e.g., AWS service) and select "EC2."
   - Attach the necessary permissions policies to the role.
   - Complete the role creation process.

2. **Attach the Role to an Instance Profile**:
   - When you create the IAM role for EC2, the console automatically creates an instance profile with the same name.
   - To launch an EC2 instance with the IAM role, go to the EC2 console.
   - Click on "Launch Instance."
   - In the "Configure Instance" step, select the IAM role from the "IAM role" dropdown. This dropdown lists instance profiles, which correspond to the roles.

### Using the AWS CLI

1. **Create an Instance Profile**:
   ```bash
   aws iam create-instance-profile --instance-profile-name <instance-profile-name>
   ```

2. **Add the IAM Role to the Instance Profile**:
   ```bash
   aws iam add-role-to-instance-profile --instance-profile-name <instance-profile-name> --role-name <role-name>
   ```

3. **Verify the Role is Attached**:
   You can check the attached roles using:
   ```bash
   aws iam get-instance-profile --instance-profile-name <instance-profile-name>
   ```

### Notes

- An instance profile can contain only one IAM role, but a role can be associated with multiple instance profiles.
- If you need to change the role associated with an instance profile, you must first remove the existing role and then add a new one.

