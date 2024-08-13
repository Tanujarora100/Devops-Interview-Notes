# CREATE A DEPLOYMENT FILE
```bash
kubectl create deployment first-deployment --image=tanujarora27/two-tier-app --replicas=1 --dry-run=client -o yaml > Deployment.yaml
```
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: first-deployment
  name: first-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: first-deployment
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: first-deployment
    spec:
      containers:
      - image: tanujarora27/two-tier-app
        name: two-tier-app
        resources:
            requests: 
            
```