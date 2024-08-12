
## 1. Use the Shadow Password File
- Shadow file stores the password in hash format + salt is added.
- `etc/passwd` file stores the user account info but not the password.
## 2. Strong Password Hashing
 - The `/etc/shadow` file typically uses SHA-512 hashing (indicated by `$6$` in the hash).
 - Unique salt added to protect against `rainbow table attacks`.


## 3. Set Appropriate File Permissions

- The `/etc/shadow` file should have strict permissions
- Should be accessible by root only.

## 4. Regularly Check File Consistency
- Use tools like `pwck` to check the consistency of the `/etc/passwd` and `/etc/shadow` files. 
## 6. Account Lockout Mechanisms
- Configure account lockout policies that temporarily disable accounts after a certain number of failed login attempts