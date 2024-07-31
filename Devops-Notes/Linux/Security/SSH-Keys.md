
## What are SSH Keys?

SSH keys consist of a pair of cryptographic keys used for authenticating a client to an SSH server. Each pair includes:

- **Public Key**: This key can be shared freely and is stored on the server in the `~/.ssh/authorized_keys`
- **Private Key**: This key is kept secret and should never be shared. It is stored on the client machine.

### Common File Extensions
#### OpenSSH Keys:
- Private Key: Typically named without an extension or with a custom extension like .openssh. The conventional name is often id_rsa for RSA keys.
- Public Key: Generally has the .pub extension, such as id_rsa.pub.
#### PuTTY Keys:
- Private Key: Uses the .ppk extension, which stands for "PuTTY Private Key". 
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

