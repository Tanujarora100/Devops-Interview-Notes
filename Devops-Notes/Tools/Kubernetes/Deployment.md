
- **Declarative Updates**: You describe the desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate.
- **Scaling**: You can scale up or down the number of pod replicas.
- **Rollouts and Rollbacks**
- **Self-Healing** 


## Creating a Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.17.0
        ports:
        - containerPort: 80
```

To create this deployment, use the `kubectl apply` command:

```bash
kubectl apply -f web-deployment.yaml
```

## Updating a Kubernetes Deployment


```yaml
spec:
  template:
    spec:
      containers:
      - name: nginx
        image: nginx:1.18.0
```

Apply the changes using `kubectl apply`:

```bash
kubectl apply -f web-deployment.yaml
```

Kubernetes will perform a rolling update, gradually replacing old pods with new ones.

## Deployment Strategies

### 1. **Recreate Deployment**

- **Description**: Terminates all existing pods before creating new ones.
- **Use Case**: Suitable for development environments where downtime is acceptable.

### 2. **Rolling Update Deployment**

- **Description**: Gradually replaces old versions of pods with new ones.
- **Use Case**: Ideal for production environments to minimize downtime.

### 3. **Blue/Green Deployment**

- **Description**: Runs two environments (blue and green) simultaneously. Traffic is switched to the new version (green) after validation.
- **Use Case**: Ensures zero downtime and easy rollback.

### 4. **Canary Deployment**

- **Description**: Routes a small portion of traffic to the new version to test in production before a full rollout.
- **Use Case**: Allows testing new features with minimal risk.

## Monitoring and Rollback

- **Monitoring**: Use `kubectl rollout status` to monitor the progress of a deployment.
- **Rollback**: If an update fails, you can rollback to a previous version using `kubectl rollout undo`:

```bash
kubectl rollout undo deployment/web-deployment
```


