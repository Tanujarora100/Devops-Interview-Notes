
### 1. Create an IAM Role for Service Accounts
You need to create an IAM role that your Kubernetes pods can assume. 

#### IAM Policy Example

Create a policy that allows S3 access:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your-bucket-name",
                "arn:aws:s3:::your-bucket-name/*"
            ]
        }
    ]
}
```


### 2. Create a Kubernetes Service Account

Create a Kubernetes service account that uses the IAM role you just created. 

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: s3-access-sa
  namespace: dev
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::your-account-id:role/your-iam-role
```


```yaml
apiVersion: v1
kind: Pod
metadata:
  name: s3-access-pod
  namespace: your-namespace
spec:
  serviceAccountName: s3-access-sa
  containers:
    - name: your-container
      image: your-image
```

### 4. Deploy the Resources

1. **Create the IAM Policy**: Use the AWS Management Console or CLI to create the IAM policy.
2. **Create the IAM Role**: Attach the policy to the role and configure it for your Kubernetes service account.
3. **Create the Service Account**: Apply the service account manifest using `kubectl`:
   ```bash
   kubectl apply -f service-account.yaml
   ```
4. **Deploy the Pod**: Apply the pod manifest:
   ```bash
   kubectl apply -f pod.yaml
   ```

No, you should not pass AWS credentials as secrets in your Kubernetes manifests. Instead, you should use IAM Roles for Service Accounts (IRSA) to grant your pods access to AWS resources without embedding credentials.

Here's why:

1. **Passing credentials in manifests is insecure**:
   - It exposes your AWS credentials in plain text, increasing the risk of unauthorized access if the manifests are accidentally shared or leaked.
   - It makes it difficult to rotate credentials as you need to update the manifests and redeploy.

2. **IAM Roles for Service Accounts (IRSA) is the recommended approach**:
   - IRSA allows you to associate an IAM role with a Kubernetes service account.
   - Pods using this service account can assume the IAM role and obtain temporary security credentials from the AWS metadata service.

3. **IRSA provides several benefits**:
   - Temporary credentials have a limited lifetime, reducing the risk of exposure.
   - Credentials are automatically rotated, so you don't need to update and redeploy your manifests.

To set up IRSA, you need to:

1. Create an IAM role with the necessary permissions (e.g., access to S3).
2. Associate this role with a Kubernetes service account.
3. Configure your pods to use this service account.

### How Temporary Credentials Work with IRSA

1. **Service Account Creation**:
   - You create a Kubernetes service account and annotate it with the ARN of the IAM role that has the necessary permissions (e.g., access to S3).

2. **Pod Configuration**:
   - When you deploy a pod, you specify that it should use the service account you created.

3. **Assuming the IAM Role**:
   - When the pod starts, the AWS SDKs or CLI tools running inside the pod will automatically check for the service account's associated IAM role.
   - The pod uses the Kubernetes API to retrieve the service account token, which is a JWT (JSON Web Token) that contains information about the service account.

4. **Requesting Temporary Credentials**:
   - The AWS SDKs or CLI will use the service account token to make a call to the AWS STS `assume-role-with-web-identity` API.
   - This call is made to STS, passing the service account token as proof of identity.

5. **Receiving Temporary Credentials**:
   - If the request is valid, STS returns temporary security credentials (an access key ID, a secret access key, and a session token) that the pod can use to access AWS resources.
   - These temporary credentials are valid for a limited duration (usually up to 1 hour).

6. **Using the Credentials**:
   - The AWS SDKs or CLI within the pod automatically use these temporary credentials for any AWS API calls (e.g., accessing S3).
   - The SDKs handle the refreshing of these credentials when they expire, ensuring that your application can continue to operate without interruption.
To install the AWS SDK in pods using init containers, you can follow these steps:

1. **Create an init container** in your pod specification that installs the necessary packages for the AWS SDK. For example, using a Debian-based image:

```yaml
initContainers:
- name: install-aws-sdk
  image: debian:bullseye-slim
  command: ["bash", "-c"]
  args:
  - |
    apt-get update
    apt-get install -y python3 python3-pip
    pip3 install boto3
  volumeMounts:
  - name: aws-sdk
    mountPath: /usr/local/lib/python3.9/site-packages
```

2. **Mount a volume** where the installed packages will be available to the main containers in the pod. In the example above, we mount the Python site-packages directory to a volume named `aws-sdk`.

3. **In your main container**, mount the same volume as the init container to access the installed AWS SDK packages:

```yaml
containers:
- name: main-container
  image: your-main-container-image
  volumeMounts:
  - name: aws-sdk 
    mountPath: /usr/local/lib/python3.9/site-packages
```

