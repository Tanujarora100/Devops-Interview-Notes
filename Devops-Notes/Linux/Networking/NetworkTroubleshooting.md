

## **1. Check Network Configuration**

### **View IP Address Configuration**
- **Command**: `ip addr`
- **Purpose**: Displays the current IP address configuration.
```bash
ip addr
```

### **Check Routing Table**
- **Command**: `ip route`
```bash
ip route
```

### **Check Network Interfaces**
- **Command**: `ip link`
- **Purpose**: Lists all network interfaces and their statuses.
```bash
ip link
```

## **2. Test Basic Connectivity**

### **Ping Command**
- **Command**: `ping`
- **Purpose**: Tests connectivity to another host.
```bash
ping -c 4 8.8.8.8  # Pings Google's public DNS server
```

### **Traceroute Command**
- **Command**: `traceroute`
- **Purpose**: Traces the path packets take to a destination.
```bash
traceroute google.com
```

## **3. Check DNS Resolution**

### **NSLookup Command**
- **Command**: `nslookup`
- **Purpose**: Queries DNS servers to resolve domain names.
```bash
nslookup google.com
```

### **Dig Command**
- **Command**: `dig`
- **Purpose**: Provides detailed DNS query information.
```bash
dig google.com
```

## **4. Check Active Connections and Listening Ports**

### **SS Command**
```bash
ss -tuln 
netstat -tulpn
```

## **5. Analyze Network Traffic**
### **Tcpdump Command**
- **Command**: `tcpdump`
```bash
sudo tcpdump -i eth0 
```
### **Wireshark**
- **Command**: `wireshark`.
```bash
sudo wireshark
```

## **6. Check Firewall Rules**

### **UFW (Uncomplicated Firewall)**
- **Command**: `ufw status`
```bash
sudo ufw status
```

### **Iptables**
- **Command**: `iptables -L`
- **Purpose**: Lists all current iptables rules.
```bash
sudo iptables -L
```

## **7. Verify Network Services**

### **Systemctl**
```bash
sudo systemctl status NetworkManager  # Example for NetworkManager service
```

### **Curl Command**

- **Purpose**: Tests HTTP connectivity and retrieves web content.
```bash
curl -I http://google.com  # Fetches HTTP headers from Google
```

### **Wget Command**
- **Purpose**: Downloads files from the web and checks connectivity.
```bash
wget -q --spider http://google.com && echo "Online" || echo "Offline"
```


## **SS VS NETSTAT**

### **netstat**
- Uses `/proc/net/tcp` and other `/proc` files 
- slower and older than ss

### **ss**
- Reads the kernel directly for traffic
- Faster
- More organized format

#### **netstat**
- **List all connections**:
  ```bash
  netstat -a
  ```
- **Show listening ports**:
  ```bash
  netstat -tuln
  ```
- **Display routing table**:
  ```bash
  netstat -r
  ```
