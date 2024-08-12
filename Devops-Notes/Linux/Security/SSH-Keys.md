
## What are SSH Keys?
Each pair includes:

- **Public Key**: This key can be shared freely and is stored on the server in the `~/.ssh/authorized_keys`
- **Private Key**: This key is kept secret and should never be shared.
- A private key cannot be convert to a public key and vice versa.

### Common File Extensions
#### OpenSSH Keys:
- Private Key: Typically named without an extension or with a custom extension like .openssh. 
- Public Key: Generally has the .pub extension, such as id_rsa.pub.
#### PuTTY Keys:
- Private Key: Uses the .ppk extension.
#### Other Formats:
- Some applications may use .pem or .der extensions

## Benefits of Using SSH Keys
1. **Enhanced Security**: Secure and harder to crack in bruteforce attacks.
2. **Convenience**: Passwordless easier for automation.
3. **No Password Transmission**: SSH keys eliminate the need to transmit passwords over the network reducing middle man attacks.

## Setting Up SSH Keys

### Step 1: Generate SSH Key Pair

```bash
ssh-keygen -t rsa -b 3072
```
### Step 2: Copy the Public Key to the Server
```bash
ssh-copy-id user@remote-server
```

### Step 4: Disable Password Authentication (Optional)

For enhanced security, consider disabling password authentication on the SSH server. Edit the SSH configuration file (`/etc/ssh/sshd_config`) and set:

```bash
PasswordAuthentication no
sudo systemctl restart sshd
```
## Passpharse
- It is used for encrypting the private key to protect the SSH key even on client side.

1. **Protection Against Key Theft**:
   A passphrase encrypts the private key, making it useless to an attacker if they manage to obtain it. Without the passphrase, the attacker cannot use the private key for authentication.

2. **Mitigating Risks from Accidental Exposure**:
   If a private key is accidentally leaked—through backups, decommissioned hardware

3. **Two-Factor Authentication**:
   A passphrase effectively acts as a second factor of authentication.



