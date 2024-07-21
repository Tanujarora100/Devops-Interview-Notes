
## **OSI Model**

1. **Physical Layer**: 
2. **Data Link Layer**: 
3. **Network Layer**: Determines how data is sent to the receiving device, including routing through different routers.
4. **Transport Layer**: Ensures complete data transfer with error recovery and flow control.
5. **Session Layer**: 
6. **Presentation Layer**: 
7. **Application Layer**: 

## **TCP/IP Model**

The **Transmission Control Protocol/Internet Protocol (TCP/IP) model** is a more practical framework for network communications, consisting of four layers:

1. **Link Layer**: Corresponds to the OSI's Physical and Data Link layers, handling the physical transmission of data.
2. **Internet Layer**: Similar to the OSI's Network layer, it manages the routing of data packets.
3. **Transport Layer**: Ensures reliable data transmission between devices, akin to the OSI's Transport layer.
4. **Application Layer**: Combines the OSI's Session, Presentation, and Application layers, providing protocols for specific data communication services[1][4].

The TCP/IP model is more streamlined and widely used in real-world networking due to its simplicity and effectiveness in practical applications[1][4].

## **IP Addressing**

### **IPv4**

- **Structure**: IPv4 addresses are 32-bit integers, represented in decimal notation as four numbers separated by dots (e.g., 192.168.1.1).
- **Address Space**: IPv4 can generate approximately 4.29 billion unique addresses.
- **Configuration**: Supports manual and DHCP address configuration.
- **Security**: Security features depend on the application layer.
- **Transmission**: Uses a broadcast message transmission scheme[2][5].

### **IPv6**

- **Structure**: IPv6 addresses are 128-bit integers, represented in hexadecimal notation as eight groups of four hexadecimal digits separated by colons (e.g., 2001:0db8:85a3:0000:0000:8a2e:0370:7334).
- **Address Space**: IPv6 provides a vastly larger address space, capable of generating 3.4×10^38 unique addresses.
- **Configuration**: Supports auto-configuration and renumbering.
- **Security**: Includes built-in security features like IPsec for data authentication and encryption.
- **Transmission**: Uses multicast and anycast message transmission schemes[2][5].

### **Key Differences**

| **Feature** | **IPv4** | **IPv6** |
|-------------|----------|----------|
| **Address Length** | 32 bits | 128 bits |
| **Address Configuration** | Manual, DHCP | Auto, renumbering |
| **Security** | Application-dependent | Built-in IPsec |
| **Transmission** | Broadcast | Multicast, anycast |
| **Fragmentation** | By sender and routers | Only by sender |
| **Checksum** | Available | Not available |
| **Header Size** | 20-60 bytes | Fixed 40 bytes[2][5] |


