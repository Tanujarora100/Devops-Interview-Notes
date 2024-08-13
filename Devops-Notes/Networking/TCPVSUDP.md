

| Feature                     | TCP (Transmission Control Protocol)                               | UDP (User Datagram Protocol)                                |
|-----------------------------|-------------------------------------------------------------------|------------------------------------------------------------|
| **Connection Type**         | Connection-oriented; establishes a connection before data transfer | Connectionless; no need for a connection before sending data |
| **Reliability**             | Reliable; guarantees delivery of data through acknowledgments       | Unreliable; does not guarantee delivery or order of packets  |
| **Error Checking**          | Extensive error-checking and recovery mechanisms                   | Basic error-checking using checksums only                    |
| **Data Transmission**       | Data is sent as a stream of bytes and is sequenced                | Data is sent as individual packets (datagrams) without sequencing |
| **Overhead**                | Higher overhead due to connection establishment and maintenance     | Lower overhead; faster transmission due to lack of connection setup |
| **Use Cases**               | Suitable for applications requiring reliable communication, such as web browsing, email, and file transfers | Ideal for applications where speed is crucial, such as online gaming, video streaming, and VoIP |
| **Flow Control**            | Implements flow control to manage data transmission rates           | No flow control; packets are sent as quickly as possible     |
| **Packet Structure**        | Packets are larger due to headers containing control information    | Packets are smaller; headers are simpler and contain minimal information |

## Real-World Applications Using UDP

1. **Voice over IP (VoIP)**  
   Applications like Skype and Zoom use UDP to transmit voice data.

2. **Online Gaming**  
   Many online multiplayer games rely on UDP to ensure smooth gameplay.

3. **Streaming Media**  
   Video and audio streaming services, such as Netflix and YouTube, often use UDP for real-time streaming.

4. **Domain Name System (DNS)**  
   DNS queries typically use UDP because they require quick responses. A DNS query consists of a single request and a reply
