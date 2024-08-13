## Admission Controllers in Kubernetes

**Definition:**
- An admission controller is a piece of code that intercepts requests to the Kubernetes API server after the request has been authenticated and authorized but before it is persisted in etcd.

**Types:**
- **Mutating Admission Controllers:** These can modify the objects in the request (e.g., adding default values, modifying resource requests).
- **Validating Admission Controllers:** These validate the objects in the request and can accept or reject the request based on custom rules

**Phases:**
1. **Mutating Phase:** Mutating admission controllers are executed first, allowing them to modify the request object.
2. **Validating Phase:** Validating admission controllers are executed next, ensuring the request complies with specific policies and rules.

**Examples of Built-in Admission Controllers:**
- **NamespaceLifecycle:** Ensures proper handling of namespace lifecycle events.
- **LimitRanger:** Enforces default resource requests and limits for pods and containers.
- **ResourceQuota:** Enforces resource quotas per namespace.
- **PodSecurityPolicy:** (Deprecated) Enforces security policies at the pod level.
- **MutatingAdmissionWebhook and ValidatingAdmissionWebhook:** Enable custom logic via webhooks.

### **Scenario-Based Questions on Admission Controllers**

### **Scenario 1: Enforcing Resource Limits**

**Question:** You want to ensure that all pods in a specific namespace have resource requests and limits defined. How would you use admission controllers to enforce this policy?

**Answer:**
1. **Enable LimitRanger Admission Controller:**
   - Ensure the `LimitRanger` admission controller is enabled in the API server configuration.
     ```sh
     --enable-admission-plugins=LimitRanger
     ```
2. **Define a LimitRange Object:**
   - Create a `LimitRange` object in the desired namespace to set default resource requests and limits.
     ```yaml
     apiVersion: v1
     kind: LimitRange
     metadata:
       name: limits
       namespace: my-namespace
     spec:
       limits:
       - default:
           cpu: "500m"
           memory: "512Mi"
         defaultRequest:
           cpu: "200m"
           memory: "256Mi"
         type: Container
     ```
3. **Apply the LimitRange:**
   - Apply the `LimitRange` object to the namespace.
     ```sh
     kubectl apply -f limitrange.yaml
     ```
4. **Result:**
   - The `LimitRanger` admission controller will automatically enforce the defined resource requests and limits for all pods in the namespace.

### **Scenario 2: Preventing Privileged Containers**

**Question:** You need to prevent the deployment of privileged containers in your cluster. How can you achieve this using admission controllers?

**Answer:**
1. **Enable PodSecurityPolicy Admission Controller:**
   - Ensure the `PodSecurityPolicy` admission controller is enabled in the API server configuration.
     ```sh
     --enable-admission-plugins=PodSecurityPolicy
     ```
2. **Define a PodSecurityPolicy:**
   - Create a `PodSecurityPolicy` that disallows privileged containers.
     ```yaml
     apiVersion: policy/v1beta1
     kind: PodSecurityPolicy
     metadata:
       name: restricted
     spec:
       privileged: false
       allowPrivilegeEscalation: false
       requiredDropCapabilities:
         - ALL
       runAsUser:
         rule: 'MustRunAsNonRoot'
       seLinux:
         rule: 'RunAsAny'
       fsGroup:
         rule: 'MustRunAs'
         ranges:
           - min: 1
             max: 65535
       supplementalGroups:
         rule: 'MustRunAs'
         ranges:
           - min: 1
             max: 65535
     ```
3. **Apply the PodSecurityPolicy:**
   - Apply the `PodSecurityPolicy` to the cluster.
     ```sh
     kubectl apply -f psp.yaml
     ```
4. **Create Role and RoleBinding:**
   - Create a `Role` and `RoleBinding` to allow specific users or service accounts to use the `PodSecurityPolicy`.
     ```yaml
     apiVersion: rbac.authorization.k8s.io/v1
     kind: Role
     metadata:
       name: use-psp
       namespace: my-namespace
     rules:
     - apiGroups: ['policy']
       resources: ['podsecuritypolicies']
       verbs: ['use']
       resourceNames: ['restricted']
     ```
     ```yaml
     apiVersion: rbac.authorization.k8s.io/v1
     kind: RoleBinding
     metadata:
       name: use-psp
       namespace: my-namespace
     subjects:
     - kind: ServiceAccount
       name: default
       namespace: my-namespace
     roleRef:
       kind: Role
       name: use-psp
       apiGroup: rbac.authorization.k8s.io
     ```
5. **Result:**
   - The `PodSecurityPolicy` admission controller will prevent the deployment of privileged containers in the cluster[2][3].

### **Scenario 3: Custom Policy Enforcement**

**Question:** Your organization requires custom policies to be enforced when creating resources in the cluster. How can you implement these custom policies using admission controllers?

**Answer:**
1. **Enable Webhook Admission Controllers:**
   - Ensure the `MutatingAdmissionWebhook` and `ValidatingAdmissionWebhook` admission controllers are enabled in the API server configuration.
     ```sh
     --enable-admission-plugins=MutatingAdmissionWebhook,ValidatingAdmissionWebhook
     ```
2. **Create a Webhook Server:**
   - Develop a webhook server that implements the custom policy logic. The server should handle `AdmissionReview` requests and respond with `AdmissionResponse` objects.
3. **Deploy the Webhook Server:**
   - Deploy the webhook server as a service in the Kubernetes cluster.
     ```yaml
     apiVersion: v1
     kind: Service
     metadata:
       name: my-webhook
       namespace: my-namespace
     spec:
       ports:
       - port: 443
         targetPort: 8443
       selector:
         app: my-webhook
     ```
4. **Create Webhook Configurations:**
   - Define `MutatingWebhookConfiguration` and `ValidatingWebhookConfiguration` resources to register the webhook server with the API server.
     ```yaml
     apiVersion: admissionregistration.k8s.io/v1
     kind: ValidatingWebhookConfiguration
     metadata:
       name: my-validating-webhook
     webhooks:
     - name: my-webhook.my-namespace.svc
       clientConfig:
         service:
           name: my-webhook
           namespace: my-namespace
           path: "/validate"
         caBundle: <base64-encoded-CA-cert>
       rules:
       - operations: ["CREATE", "UPDATE"]
         apiGroups: ["*"]
         apiVersions: ["*"]
         resources: ["*"]
       admissionReviewVersions: ["v1", "v1beta1"]
       sideEffects: None
     ```
5. **Result:**
   - The custom webhook server will enforce the custom policies by validating or mutating requests based on the implemented logic[2][5].

### **Scenario 4: Enforcing Image Pull Policies**

**Question:** You want to ensure that all images are always pulled from the registry, even if they are already present on the node. How can you enforce this policy using admission controllers?

**Answer:**
1. **Enable AlwaysPullImages Admission Controller:**
   - Ensure the `AlwaysPullImages` admission controller is enabled in the API server configuration.
     ```sh
     --enable-admission-plugins=AlwaysPullImages
     ```
2. **Result:**
   - The `AlwaysPullImages` admission controller will modify every new Pod to force the image pull policy to `Always`, ensuring that images are always pulled from the registry before starting containers.

## Differences Between Mutating and Validating Admission Controllers

Admission controllers in Kubernetes are essential components that intercept requests to the Kubernetes API server before they are persisted. They can be categorized into two main types: mutating and validating. Here’s a detailed comparison of these two types of admission controllers:

### **Mutating Admission Controllers**

**Purpose:**
- Mutating admission controllers are designed to modify or mutate the objects in the requests they intercept. Their primary role is to enforce custom defaults, add or modify labels, annotations, or other resource attributes before the request is validated and persisted.

**Functionality:**
- **Modification:** They can change the content of the request, such as adding default values, modifying resource specifications, or injecting sidecar containers.
- **Order of Execution:** Mutating admission controllers are executed first in the admission control process.
- **Idempotency:** Mutating webhooks must be idempotent, meaning they should be able to process an object they have already modified without causing issues.

**Example Use Cases:**
- Adding default resource requests and limits to pods that do not specify them.
- Injecting sidecar containers for logging or monitoring purposes.
- Automatically adding labels or annotations to resources.

**Example Configuration:**
```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
webhooks:
  - name: my-mutating-webhook.example.com
    clientConfig:
      service:
        name: my-webhook-service
        namespace: my-namespace
        path: "/mutate"
      caBundle: <base64-encoded-CA-cert>
    rules:
      - operations: ["CREATE", "UPDATE"]
        apiGroups: ["*"]
        apiVersions: ["*"]
        resources: ["*"]
    reinvocationPolicy: IfNeeded
    failurePolicy: Fail
```

### **Validating Admission Controllers**

**Purpose:**
- Validating admission controllers are designed to validate the objects in the requests they intercept. Their primary role is to ensure that the requests comply with predefined policies and rules before they are persisted.

**Functionality:**
- **Validation:** They do not modify the request objects. Instead, they inspect the requests and either accept or reject them based on custom validation logic.
- **Order of Execution:** Validating admission controllers are executed after all mutating admission controllers have been processed.
- **Declarative Policies:** They can use declarative policies, such as those defined using the Common Expression Language (CEL), to enforce complex validation rules.

**Example Use Cases:**
- Ensuring that all pods have specific labels or annotations.
- Validating that resource requests and limits are within acceptable ranges.
- Enforcing security policies, such as disallowing privileged containers.

**Example Configuration:**
```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
webhooks:
  - name: my-validating-webhook.example.com
    clientConfig:
      service:
        name: my-webhook-service
        namespace: my-namespace
        path: "/validate"
      caBundle: <base64-encoded-CA-cert>
    rules:
      - operations: ["CREATE", "UPDATE"]
        apiGroups: ["*"]
        apiVersions: ["*"]
        resources: ["*"]
    failurePolicy: Fail
```

### **Comparison Table**

| Feature                        | Mutating Admission Controllers              | Validating Admission Controllers             |
|--------------------------------|--------------------------------------------|----------------------------------------------|
| **Primary Purpose**            | Modify or mutate request objects           | Validate request objects                     |
| **Order of Execution**         | Executed first                             | Executed after mutating controllers          |
| **Modification Capability**    | Can modify request objects                 | Cannot modify request objects                |
| **Idempotency Requirement**    | Must be idempotent                         | Not applicable                               |
| **Use Cases**                  | Adding defaults, injecting sidecars        | Enforcing policies, validating configurations|
| **Example Configuration**      | MutatingWebhookConfiguration               | ValidatingWebhookConfiguration               |



## Phases of the Admission Control Process in Kubernetes

### **1. Mutating Phase**

**Purpose:**
- The mutating phase is responsible for modifying or augmenting the incoming request objects before they are validated and persisted. 
- This phase allows for the automatic addition of default values, labels, annotations, and other modifications that ensure the request conforms to the desired state.

**Functionality:**
- **Modification:** Mutating admission controllers can change the content of the request. 
- For example, they can inject sidecar containers, set default resource requests and limits, or add necessary labels and annotations.
- **Order of Execution:** All mutating admission controllers are executed in a specific order, one after the other. 
   ` - The order is important because the output of one mutating controller can be the input for the next`.

**Example Use Cases:**
- **Injecting Sidecars:** Automatically adding a logging or monitoring sidecar container to every pod.
- **Setting Defaults:** Ensuring that all pods have default resource requests and limits if they are not explicitly specified.

**Example Configuration:**
```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
webhooks:
  - name: my-mutating-webhook.example.com
    clientConfig:
      service:
        name: my-webhook-service
        namespace: my-namespace
        path: "/mutate"
      caBundle: <base64-encoded-CA-cert>
    rules:
      - operations: ["CREATE", "UPDATE"]
        apiGroups: ["*"]
        apiVersions: ["*"]
        resources: ["*"]
    reinvocationPolicy: IfNeeded
    failurePolicy: Fail
```

### **2. Validating Phase**

**Purpose:**
- The validating phase ensures that the request objects comply with the cluster's policies and rules. This phase is responsible for enforcing security policies, resource quotas.

**Functionality:**
- **Validation:** Validating admission controllers inspect the request objects and either accept or reject them based on predefined criteria. 
- **Order of Execution:** All validating admission controllers are executed after the mutating controllers have completed their modifications. 
  - The order of execution is also important to ensure that all necessary validations are performed.

**Example Use Cases:**
- **Enforcing Security Policies:** Ensuring that no privileged containers are deployed in the cluster.
- **Resource Quotas:** Validating that the resource requests and limits of a pod do not exceed the quotas defined for the namespace.

**Example Configuration:**
```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
webhooks:
  - name: my-validating-webhook.example.com
    clientConfig:
      service:
        name: my-webhook-service
        namespace: my-namespace
        path: "/validate"
      caBundle: <base64-encoded-CA-cert>
    rules:
      - operations: ["CREATE", "UPDATE"]
        apiGroups: ["*"]
        apiVersions: ["*"]
        resources: ["*"]
    failurePolicy: Fail
```

### **Interaction Between Phases**

- **Sequential Execution:** The mutating phase always precedes the validating phase. 
  - This ensures that any modifications made by mutating controllers are validated by the validating controllers.
- **Rejection Handling:** If any controller in either phase rejects the request, the entire request is rejected, and an error is returned to the end-user. This ensures that only requests that fully comply with all policies and rules are allowed to proceed.

## Writing a Validating Admission Controller in Kubernetes


### **Prerequisites**

- Kubernetes cluster with `MutatingAdmissionWebhook` and `ValidatingAdmissionWebhook` admission controllers enabled.
- Go programming language installed.
- `kubectl` command-line tool installed.
- Docker installed for building the webhook image.

### **Step-by-Step Guide**

### **1. Create the Webhook Server**

```sh
mkdir validating-webhook
cd validating-webhook
go mod init validating-webhook
```

Create a main Go file (`main.go`) and add the following code to set up the webhook server:

```go
package main

import (
    "context"
    "encoding/json"
    "net/http"
    "log"

    admissionv1 "k8s.io/api/admission/v1"
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
    "sigs.k8s.io/controller-runtime/pkg/client"
    "sigs.k8s.io/controller-runtime/pkg/webhook/admission"
)

// Validator validates admission requests
type Validator struct {
    Client  client.Client
    Decoder *admission.Decoder
}

// Handle handles admission requests
func (v *Validator) Handle(ctx context.Context, req admission.Request) admission.Response {
    // Example: Validate that all pods have a specific label
    if req.Kind.Kind != "Pod" {
        return admission.Allowed("Not a Pod resource")
    }

    pod := &corev1.Pod{}
    err := v.Decoder.Decode(req, pod)
    if err != nil {
        return admission.Errored(http.StatusBadRequest, err)
    }

    // Check for the required label
    if _, ok := pod.Labels["required-label"]; !ok {
        return admission.Denied("Missing required label: required-label")
    }

    return admission.Allowed("Pod has the required label")
}

func main() {
    // Set up the webhook server
    http.HandleFunc("/validate", func(w http.ResponseWriter, r *http.Request) {
        admissionReview := admissionv1.AdmissionReview{}
        if err := json.NewDecoder(r.Body).Decode(&admissionReview); err != nil {
            http.Error(w, err.Error(), http.StatusBadRequest)
            return
        }

        validator := &Validator{}
        response := validator.Handle(context.Background(), admissionReview.Request)
        admissionReview.Response = &response

        if err := json.NewEncoder(w).Encode(admissionReview); err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
        }
    })

    log.Println("Starting webhook server on port 8443...")
    if err := http.ListenAndServeTLS(":8443", "/tls/tls.crt", "/tls/tls.key", nil); err != nil {
        log.Fatalf("Failed to start server: %v", err)
    }
}
```

### **2. Build and Containerize the Webhook Server**

Create a Dockerfile to build and containerize the webhook server:

```Dockerfile
FROM golang:1.16 as builder
WORKDIR /workspace
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o webhook main.go

FROM alpine:3.13
WORKDIR /root/
COPY --from=builder /workspace/webhook .
ENTRYPOINT ["./webhook"]
```

Build and push the Docker image:

```sh
docker build -t <your-dockerhub-username>/validating-webhook:latest .
docker push <your-dockerhub-username>/validating-webhook:latest
```

### **3. Deploy the Webhook Server in Kubernetes**

Create a Kubernetes deployment and service for the webhook server:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: validating-webhook
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: validating-webhook
  template:
    metadata:
      labels:
        app: validating-webhook
    spec:
      containers:
      - name: webhook
        image: <your-dockerhub-username>/validating-webhook:latest
        ports:
        - containerPort: 8443
        volumeMounts:
        - name: webhook-certs
          mountPath: /tls
          readOnly: true
      volumes:
      - name: webhook-certs
        secret:
          secretName: webhook-certs
---
apiVersion: v1
kind: Service
metadata:
  name: validating-webhook
  namespace: default
spec:
  ports:
  - port: 443
    targetPort: 8443
  selector:
    app: validating-webhook
```

### **4. Create TLS Certificates**

Generate TLS certificates for the webhook server. You can use tools like OpenSSL or cert-manager to create the certificates. Store the certificates in a Kubernetes secret:

```sh
kubectl create secret generic webhook-certs --from-file=tls.crt --from-file=tls.key
```

### **5. Configure the ValidatingWebhookConfiguration**

Create a `ValidatingWebhookConfiguration` to register the webhook with the Kubernetes API server:

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: validating-webhook
webhooks:
  - name: validating-webhook.default.svc
    clientConfig:
      service:
        name: validating-webhook
        namespace: default
        path: "/validate"
      caBundle: <base64-encoded-CA-cert>
    rules:
      - operations: ["CREATE", "UPDATE"]
        apiGroups: [""]
        apiVersions: ["v1"]
        resources: ["pods"]
    admissionReviewVersions: ["v1"]
    failurePolicy: Fail
```

Apply the configuration:

```sh
kubectl apply -f validating-webhook-configuration.yaml
```

### **6. Test the Validating Admission Controller**

Create a pod without the required label to test the admission controller:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: nginx
    image: nginx
```

Apply the pod configuration:

```sh
kubectl apply -f test-pod.yaml
```
