In AWS, a **Trust Entity** is a concept used in the context of Identity and Access Management (IAM) roles. 

### Key Concepts of Trust Entities:

1. **IAM Roles**:
   - IAM Roles are similar to users in that they are associated with permissions policies that define what actions the role can perform on which resources. 
   - However, instead of being associated with a single user, roles can be assumed by any entity specified in the trust policy.

2. **Trust Policy**:
   - Each IAM role has a trust policy attached to it. The trust policy specifies which entities can use the role. This is done using a JSON policy document.

3. **Trusted Entities**:
   - Trusted entities are the entities allowed to assume the role. These can be:
     - **AWS services**: Such as EC2, Lambda, etc., 
     - **IAM Users**: Specific users within your account or another AWS account.
     - **IAM Roles**: Roles from the same or different AWS accounts that can assume the role.
     - **AWS Accounts**: Entire AWS accounts can be trusted to assume a role, allowing any user or role in that account to assume it.
     - **Federated Users**: Users from an external identity provider (e.g., SAML, OpenID Connect) who are authenticated through federation.

4. **AssumeRole**:
   - For an entity to assume a role, the entity must have permissions to perform the `sts:AssumeRole` action. This is granted in the entity's policy.

5. **Use Cases**:
   - **Cross-account access**: An IAM role can be configured to allow users or services in another AWS account to assume it.
   - **AWS services**: Services like EC2 or Lambda can assume roles to gain temporary access to AWS resources.

### Example of a Trust Policy

Here is an example of a trust policy that allows the EC2 service to assume a role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```


