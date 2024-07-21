## **Role of Identity Providers and Service Providers**

### **Identity Providers (IdPs)**

**Definition:** An Identity Provider (IdP) is an entity that creates, stores, and manages digital identities. It authenticates users and provides identity information to Service Providers (SPs) to facilitate access to services and resources.

**Key Functions:**
- **Authentication:** 
- **Identity Management:** 
- **Federation:** IdPs establish trust relationships with SPs, enabling users to access multiple services

**Examples:** Common IdPs include platforms like Google, Facebook, Microsoft Azure Active Directory.

**Protocols Used:**
- **SAML (Security Assertion Markup Language):** 
- **OpenID Connect (OIDC):** An identity layer on top of OAuth 2.0, used for verifying the identity of users.

### **Service Providers (SPs)**

**Definition:** A Service Provider (SP) is an entity that offers services, such as applications or resources, to users.

**Key Functions:**
- **Service Delivery:** 
- **Authorization:** Authorization is taken care by the service provider but if we are using OpenConnect then it can take care of that.
- **Trust Relationship:** SPs trust the IdP to authenticate users and provide accurate identity information.
