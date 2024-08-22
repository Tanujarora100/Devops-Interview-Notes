
## Docker Networks

### List Docker Networks
```sh
docker network ls
```

### Create a Custom Bridge Network
```sh
docker network create my_custom_network
```

### Create a Container on a Specific Network
```sh
docker run --name container1 --network my_custom_network -d nginx
```

### Inspect Network Details
```sh
docker network inspect my_custom_network
```

### Create a Container with a Specific IP Address
```sh
docker run --name container2 --network my_custom_network --ip 172.18.0.10 -d nginx
```

### Connect an Existing Container to a Network
```sh
docker network connect my_custom_network container1
```

### Disconnect a Container from a Network
```sh
docker network disconnect my_custom_network container1
```

### Remove a Custom Network
```sh
docker network rm my_custom_network
```

## Docker Network Types

### Bridge Network (bridge)
- **Description**: The default network mode for Docker containers when no network is specified. 
- It creates an internal private network on the host, and containers can communicate with each other using container names.
- **Use Cases**: Suitable for most containerized applications where containers need to communicate on the same host.

### Host Network (host)
- **Description**: Containers share the host network stack, **making them directly accessible from the host** and other containers without any network address translation (NAT).
- **Use Cases**: High-performance scenarios where containers need to bind to specific host ports, but it lacks network isolation.

### Overlay Network (overlay)
- **Description**: Used in Docker Swarm mode to facilitate communication between containers running on different nodes in a swarm cluster. 
- **It uses VXLAN encapsulation for inter-node communication.**
- **Use Cases**: Multi-host, multi-container applications orchestrated with Docker Swarm.

### Macvlan Network (macvlan)
- **Description**: Allows containers to have their own MAC addresses and **appear as separate devices on the host network**. 
- Each container has a unique network identity.
- **Use Cases**: When containers need to be directly on an external network, e.g., connecting containers to physical networks or VLANs.

### None Network (none)
- **Description**: Containers on this network have no network connectivity. 
- It's often used for isolated testing or when the container only needs loopback connectivity.
- **Use Cases**: Limited use cases, primarily for debugging or security purposes.

### Custom Bridge Network (user-defined bridge)
- **Use Cases**: Isolating containers, customizing DNS settings, or when you need multiple bridge networks on the same host.

### Overlay2 Network (overlay2)
- **Description**: Introduced in `Docker 20.10`, the Overlay2 network driver is optimized.

### Cilium Network (cilium)
- **Description**: Cilium is an open-source networking and security project that offers advanced networking features
  - API-aware network 
  - security and load balancing.
- **Use Cases**: Advanced networking and security requirements, often in Kubernetes environments.

### Gossip Network (gossip)
- **Description**: Used in Docker Swarm mode to enable gossip-based cluster management for container orchestration and service discovery.