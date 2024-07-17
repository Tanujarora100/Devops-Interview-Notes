
#### **Method 1: Installing Kyverno using Helm**
Helm is the recommended method for installing Kyverno in a production environment due to its flexibility and ease of configuration.

**Steps**:

1. **Add the Kyverno Helm Repository**:
   ```sh
   helm repo add kyverno https://kyverno.github.io/kyverno/
   helm repo update
   ```

2. **Install Kyverno**:
   ```sh
   helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace
   ```

3. **Install Kyverno Policies** (optional):
   ```sh
   helm install kyverno-policies kyverno/kyverno-policies --namespace kyverno
   ```

4. **Install with High Availability** (optional):
   ```sh
   helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace --set replicaCount=3
   ```

**Example**:
```sh
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace
```

#### **Method 2: Installing Kyverno using YAML Manifests**

For a simpler installation or for environments where Helm is not available, you can use YAML manifests.

**Steps**:

1. **Apply the Installation YAML**:
   ```sh
   kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/main/config/install.yaml
   ```

**Example**:
```sh
kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/main/config/install.yaml
```

#### **Verifying Installation**

After installing Kyverno, you can verify that it is running correctly by checking the status of the Kyverno pods.

1. **Check the Kyverno Pods**:
   ```sh
   kubectl get pods -n kyverno
   ```

2. **Check the Logs** (if needed):
   ```sh
   kubectl logs -l app.kubernetes.io/name=kyverno -n kyverno
   ```

**Example**:
```sh
kubectl get pods -n kyverno
kubectl logs -l app.kubernetes.io/name=kyverno -n kyverno
```

### Summary

Kyverno can be installed using Helm or YAML manifests. Helm is recommended for production environments due to its flexibility and ease of configuration. After installation, verify the Kyverno pods to ensure they are running correctly. Here are the key commands for both methods:

#### **Helm Installation**:
```sh
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace
```

#### **YAML Installation**:
```sh
kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/main/config/install.yaml
```

#### **Verification**:
```sh
kubectl get pods -n kyverno
kubectl logs -l app.kubernetes.io/name=kyverno -n kyverno
```
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-requests-limits
  annotations:
    policies.kyverno.io/title: Require Limits and Requests
    policies.kyverno.io/category: Best Practices
    policies.kyverno.io/severity: medium
    policies.kyverno.io/subject: Pod
    policies.kyverno.io/minversion: 1.6.0
    policies.kyverno.io/description: >-
      As application workloads share cluster resources, it is important to limit resources
      requested and consumed by each Pod. It is recommended to require resource requests and
      limits per Pod, especially for memory and CPU. If a Namespace level request or limit is specified,
      defaults will automatically be applied to each Pod based on the LimitRange configuration.
      This policy validates that all containers have something specified for memory and CPU
      requests and memory limits.
spec:
  validationFailureAction: enforce
  background: true
  rules:
    - name: validate-resources
      match:
        any:
          - resources:
              kinds:
                - Pod
      validate:
        message: "CPU and memory resource requests and limits are required."
        pattern:
          spec:
            containers:
              - resources:
                  requests:
                    memory: "?*"
                    cpu: "?*"
                  limits:
                    memory: "?*"
                    cpu: "?*"
```