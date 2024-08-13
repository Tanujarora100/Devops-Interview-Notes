### Manual Scheduling:

- NodeName is not set when the yaml file is created and the scheduler looks for this property if it is not set and identifies and **schedules the pod on that node by creating a binding object.**
    - Binding object bind kardeta hai pod ko node ke saath.
- By setting the node name field before creating a pod
- We cannot change the **node name of the pod if it is already created.**

### How do you schedule an already running pod on a different node without destroying it ?
- Second way is to schedule an already running pod is to create a binding object and then send that binding object as a **POST Request to the running pod to schedule it.**
    - For this we need to convert the YAML file to a json object and send it using curl
    - Binding object is also a resource in kubernetes when we do the scheduling automatically it creates it but if we want to change the node on a running pod then we need to create the binding object and send it as json object.
    1. Convert the YAML file to a JSON object.
    2. Send the JSON object using cURL as a POST request to the pod.

```bash
cat your_pod.yaml | yq r -j - | jq 'del(.status, .metadata.creationTimestamp, .metadata.selfLink, .metadata.uid)' > pod.json
curl -X POST \
  -H "Content-Type: application/json" \
  -d @pod.json \
  http://your-pod-ip:your-port/schedule

```


- **Scheduler**
    - Control plane component that handles scheduling
    - Watches newly created Pods and finds best Node for it
- **Taken into account by scheduler:**
    - Resource requests and **available node resources**
        - Resource quotas we have created at the namespace level
    - Various configurations that affect scheduling using node labels
        - ie. `nodeSelector`
    - Taints and tolerations present on the node itself.
