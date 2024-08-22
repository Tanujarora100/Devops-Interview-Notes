# How Docker Daemon Communicates with Docker Client

Docker uses a client-server architecture where the Docker client and Docker daemon communicate to manage and execute Docker containers.
   - Client issue commands like `docker build`, `docker pull`.
  -  Docker daemon (`dockerd`) is a background process 
   - These Communicate over the REST API on Socket `/var/run/docker.sock`
   - Need to create a TCP Socket if the docker daemon and docker client are on remote servers.

### **Example Communication Flow**
   - The Docker client translates command into an API request.
   - The Docker client sends the API request to the Docker daemon over (Unix socket or TCP).
   - The Docker daemon receives the API request, processes it
- The Docker client communicates with the Docker daemon.
- The Docker daemon prepares the container's environment, including setting up the network namespace, bridge, veth pairs, IP address, and iptables rules.
- The Docker daemon then invokes runc to create the container process.
- The container process starts running in its isolated environment, with network connectivity managed through the host's bridge and NAT setup.