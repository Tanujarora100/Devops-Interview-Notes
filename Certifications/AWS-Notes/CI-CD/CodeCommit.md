- AWS managed **private** remote Git repository
- `No repo size limit`
- Code, application and infrastructure within AWS Cloud ⇒ **increased security**
- Enable repository level notifications on an **SNS topic**
- GitHub is far better

## Security

- Authentication using SSH keys (key file) or HTTPS (enter username and password manually)
- Authorization using `IAM`
- **Repos are encrypted by default** (at rest using KMS keys and in flight using HTTPS or SSH)
- For cross-account access, create an IAM Role and use STS AssumeRole API to get access to CodeCommit Repo

## Misc
- IAM supports CodeCommit with three types of credentials:
    - **Git credentials**: an IAM-generated username and password pair you can use to communicate with CodeCommit repositories over **HTTPS**
    - **SSH keys**: a locally generated public-private key pair that you can associate with your IAM user to communicate with CodeCommit repositories over **SSH**
    - **AWS access keys**: which you can use with the **Git Credential Helper** included with the AWS CLI to communicate with CodeCommit repositories over **HTTPS**
- **cURL cannot be used to work with the CodeCommit API** `(must use AWS SDK)`
- Recommended to generate Git credentials in the IAM console to access repos in CodeCommit