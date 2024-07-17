```sh
kubeadm join 34.41.76.203:6443 --token yvfyrc.yv8wpybx36wed4zt \
        --discovery-token-ca-cert-hash sha256:79f7c7f3b19fa6aa827c692c46eacb815db68b77b2bb56404d6efabc1ea4482b
```
### Troubleshooting `kubeadm join` Error: "couldn't validate the identity of the API Server"

The error message indicates that the `kubeadm join` command failed because the cluster CA found in the `cluster-info` ConfigMap is invalid. 
- This typically means that the public key hash provided does not match the expected hash.

#### **1. Verify the CA Certificate Hash**

Ensure that the CA certificate hash (`--discovery-token-ca-cert-hash`) provided in the `kubeadm join` command is correct. You can regenerate the hash using the following command on the control plane node:

```sh
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl pkey -pubin -outform DER | openssl dgst -sha256 -hex | sed 's/^.* //'
```

This command will output the correct hash. Ensure that this hash matches the one used in your `kubeadm join` command.

#### **2. Generate a New Token**

If the token has expired or is invalid, generate a new token on the control plane node:

```sh
kubeadm token create --print-join-command
```

This command will generate a new token and print the full `kubeadm join` command, including the correct CA certificate hash.

#### **3. Check the `cluster-info` ConfigMap**

Ensure that the `cluster-info` ConfigMap in the `kube-public` namespace is correctly configured. You can inspect it using the following command:

```sh
kubectl -n kube-public get cm cluster-info -o yaml
```

Verify that the `certificate-authority-data` and `server` fields are correctly set.

#### **4. Ensure Network Connectivity**

Make sure that the worker node can reach the control plane node on the specified IP and port (6443). You can test this using `nc` (netcat) or `curl`:

```sh
nc -zv 34.41.76.203 6443
```

or

```sh
curl https://34.41.76.203:6443
```

If there are network issues, ensure that there are no firewalls or security groups blocking the traffic.

#### **5. Run `kubeadm join` with Verbose Logging**

To get more detailed information about the error, run the `kubeadm join` command with increased verbosity:

```sh
kubeadm join 34.41.76.203:6443 --token yvfyrc.yv8wpybx36wed4zt \
  --discovery-token-ca-cert-hash sha256:79f7c7f3b19fa6aa827c692c46eacb815db68b77b2bb56404d6efabc1ea4482b --v=5
```
