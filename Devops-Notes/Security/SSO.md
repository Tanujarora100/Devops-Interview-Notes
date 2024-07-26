## **How Single Sign-On (SSO) Works**
 

### **Key Components**

1. **Identity Provider (IdP):** The entity that authenticates the user and provides identity information to the service providers.Eg: AWS Cognito
2. **Service Provider (SP):** The entity that offers the service or application the user wants to access.
3. **Authentication Token:** A digital piece of information that verifies the user’s identity and is passed between the IdP and SP.

### **SSO Workflow**

1. **User Request:** User Request the service provider
2. **Redirection to IdP:** Service Provider sends this request to IDP.
3. **User Authentication:** The IdP authenticates the user using their credentials.
4. **Token Issuance:** IDP Generates a token and then gives it to the service provider.
5. **Token Verification:** The SP receives the token and verifies its validity.
6. **Access Granted:** Once verified, the SP grants the user access to the requested service.

### **Detailed Steps**

1. **Initial Access Attempt:**
   - The user tries to access an application (SP).
   - The application detects that the user is not authenticated and redirects them to the IdP.

2. **Authentication at IdP:**
   - The user is presented with a login page by the IdP.
   - The user enters their credentials, which the IdP verifies against its database.
   - If the credentials are valid, the IdP creates an authentication token.

3. **Token Generation and Redirection:**
   - The authentication token contains user identity information and is signed by the IdP.

4. **Token Verification at SP:**
   - The SP receives the token and verifies its signature to ensure it was issued by a trusted IdP.
   - The SP extracts the user identity information from the token.

5. **Access Provision:**
   - The user can now access the application without needing to log in again.

6. **Subsequent Access to Other Applications:**
   - The second application redirects the user to the IdP.
   - Since the user is already authenticated, the IdP issues a new token without requiring the user to log in again.

### **SSO Protocols**

- **SAML (Security Assertion Markup Language):** An XML-based protocol.
- **OpenID Connect (OIDC):** An identity layer on top of OAuth 2.0, using JSON Web Tokens (JWT) to convey identity information.


### **Security Considerations**

- **Single Point of Failure:** If the IdP is compromised, all connected services are at risk. 
- **Token Security:** Tokens must be securely transmitted.

## **Role of SAML in Single Sign-On (SSO)**
### **What is SAML?**

SAML is an XML-based open standard used for exchanging authentication and authorization information between parties, specifically between an IdP and an SP. 


| Feature/Aspect              | SAML (Security Assertion Markup Language) | OpenID Connect (OIDC)                      |
|-----------------------------|-------------------------------------------|-------------------------------------------|
| **Year Introduced**         | 2005                                      | 2014                                      |
| **Protocol Type**           | Authentication and Authorization          | Authentication (built on OAuth 2.0)       |
| **Data Format**             | XML                                       | JSON                                      |
| **Transport Mechanism**     | HTTP or SOAP                              | RESTful APIs                              |
| **Token Type**              | SAML Assertion                            | ID Token (JWT)                            |
| **Primary Use Cases**       | Enterprise and Government applications, Web SSO | Consumer applications, Mobile and Web apps |
| **Ease of Implementation**  | Complex, requires handling XML            | Simpler, uses JSON                        |
| **Supported Applications**  | Web applications                          | Web and Mobile applications               |
| **Identity Provider (IdP)** | Identity Provider (IdP)                   | OpenID Provider (OP)                      |
| **Service Provider (SP)**   | Service Provider (SP)                     | Relying Party (RP)                        |
| **Security**                | Mature and feature-rich, supports multi-factor authentication | Modern, evolving, focuses on simplicity and performance |
| **Scalability**             | Suitable for large, complex systems       | Highly scalable, suitable for modern apps |


