
## **Encryption at Rest**

### **1. Server-Side Encryption (SSE)**
AWS provides server-side encryption options for many of its services, such as Amazon S3, Amazon EBS, Amazon RDS:

- **SSE-S3 (Amazon S3 Managed Keys)**: Amazon S3 handles the encryption and decryption of objects using keys managed by AWS. 
    - Each object is encrypted with a unique key, which is itself encrypted with a master key that is regularly rotated by AWS. 

- **SSE-KMS (AWS Key Management Service)**: This method integrates with AWS KMS, allowing users to manage their encryption keys. 
    - Users can create, manage, and audit the keys used for encryption.

- **SSE-C (Customer-Provided Keys)**: Users manage their encryption keys and provide them to AWS for encrypting and decrypting data. 
    - AWS does not store the keys, providing users with full control over their encryption process.

### **2. Client-Side Encryption**
In client-side encryption, data is encrypted by the client before being uploaded to AWS. 
- The encryption process, keys, and related tools are managed by the user.

## **Encryption in Transit**

### **1. Transport Layer Security (TLS)**
AWS uses TLS to encrypt data in transit between clients and AWS services.

### **2. Secure Socket Layer (SSL)**
SSL is another protocol used to encrypt data in transit. It works similarly to TLS

## **Key Management**

### **3. Envelope Encryption**
- Envelope encryption is a technique where data is encrypted with a data key, which is then encrypted with a master key. 
- This method enhances security by adding multiple layers of encryption and is supported by AWS KMS.



## **Definitions**

### **Encryption**
Encryption is the process of converting plaintext (readable data) into ciphertext (unreadable data) using an algorithm and an encryption key. 

### **Hashing**
Hashing is the process of converting data of any size into a fixed-length hash value using a hash function. The primary purpose of hashing is to ensure data integrity, meaning that any change in the input data will result in a different hash value.

### **Encryption**
- **Confidentiality**: Protects data from unauthorized access by making it unreadable without the decryption key.

### **Hashing**
- **Authentication**: Commonly used for verifying the authenticity of data, such as passwords and digital signatures.
- **One-Way Process**: Data is converted into a hash value, which cannot be reversed to obtain the original data.

## **Mechanism**

### **Encryption**
- **Symmetric Encryption**: Uses the same key for both encryption and decryption (e.g AES).
- **Asymmetric Encryption**: Uses a pair of keys (public and private) for encryption and decryption (RSA)

### **Hashing**
- **Process**: 
  1. **Hashing**: Input Data + Hash Function → Hash Value
  2. **Verification**: Compare the hash value of the input data with the stored hash value to check for integrity.

## **Examples**

### **Encryption Algorithms**
- **AES (Advanced Encryption Standard)**
- **RSA (Rivest-Shamir-Adleman)**
- **Blowfish**

### **Hashing Algorithms**
- **MD5 (Message Digest Algorithm 5)**
- **SHA-256 (Secure Hash Algorithm 256-bit)**
- **SHA-1 (Secure Hash Algorithm 1)**

## **Comparison Table**

| **Aspect**           | **Encryption**                                                                 | **Hashing**                                                                 |
|----------------------|--------------------------------------------------------------------------------|------------------------------------------------------------------------------|
| **Definition**       | Converts plaintext into ciphertext using an algorithm and key                  | Converts data into a fixed-length hash value using a hash function           |
| **Purpose**          | Ensures data confidentiality                                                   | Ensures data integrity                                                       |
| **Process**          | Two-way (encrypt and decrypt)                                                  | One-way (irreversible)                                                       |
| **Key Management**   | Requires keys for encryption and decryption                                    | No keys required                                                             |
| **Output**           | Ciphertext (variable length)                                                   | Hash value (fixed length)                                                    |
| **Reversibility**    | Reversible with the correct decryption key                                     | Irreversible                                                                 |
| **Use Cases**        | Secure data transmission, storage, and communication                           | Password storage, data integrity checks, digital signatures                  |
| **Examples**         | AES, RSA, Blowfish                                                             | MD5, SHA-256, SHA-1                                                          |

