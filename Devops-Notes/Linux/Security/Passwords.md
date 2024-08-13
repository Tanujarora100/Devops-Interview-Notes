
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

### Shadow Password in Linux

The `/etc/shadow` file in Linux is a critical system file that stores secure user account information, specifically the hashed passwords and associated password aging information. This file is only accessible to the root user and certain privileged processes, enhancing the security of user passwords.

#### Structure of `/etc/shadow`

Each line in the `/etc/shadow` file corresponds to a user account and contains multiple fields separated by colons (`:`). Here is a breakdown of these fields:

1. **Username**: The login name of the user.
2. **Password**: The hashed password. This field can also contain special symbols like `!`, `!!`, or `*` to indicate different states of the password.
3. **Last Password Change**: The date of the last password change, expressed as the number of days since January 1, 1970 (Unix epoch).
4. **Minimum Password Age**: The minimum number of days required between password changes.
5. **Maximum Password Age**: The maximum number of days a password is valid before the user must change it.

#### Example Entry

Here is an example entry from the `/etc/shadow` file:

```plaintext
user1:$6$randomsalt$hashedpassword:19278:0:99999:7:::
```

This entry represents the following:
- **Username**: `user1`
- **Password**: `$6$randomsalt$hashedpassword` (hashed using SHA-512)
- **Last Password Change**: 19278 days since January 1, 1970
- **Minimum Password Age**: 0 days
- **Maximum Password Age**: 99999 days
- **Password Warning Period**: 7 days
- **Password Inactivity Period**: Not set
- **Account Expiration Date**: Not set
- **Reserved Field**: Not used

#### Special Symbols in Password Field

- **`*`**: Indicates that the account is locked and cannot be used for login.
- **`!`**: Indicates that the password is locked, but other login methods (e.g., SSH keys) may still work.
- **`!!`**: Typically indicates that the account has been created but no password has been set yet.

#### Commands for Managing `/etc/shadow`

- **`passwd`**: Change a user's password.
- **`chage`**: Change the password aging information.
- **`vipw -s`**: Safely edit the `/etc/shadow` file (locks the file during editing, similar to `visudo` for `/etc/sudoers`).

#### Security Considerations

The `/etc/shadow` file is not world-readable, unlike the `/etc/passwd` file, which is necessary for various system utilities to map user IDs to usernames. This restriction helps protect the hashed passwords from unauthorized access and potential brute-force attacks.