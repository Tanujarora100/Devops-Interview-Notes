
## 1. Use the Shadow Password File
- Shadow file stores the password in hash format + salt is added.
- `etc/passwd` file stores the user account info but not the password.

## 2. Strong Password Hashing
 - The `/etc/shadow` file typically uses SHA-512 hashing 
 - Unique salt added to protect against `rainbow table attacks`.


## 3. Set Appropriate File Permissions
- The `/etc/shadow` file should have strict permissions
- Should be accessible by root only.

## 4. Regularly Check File Consistency
- Use tools like `pwck` to check the consistency of the `/etc/passwd` and `/etc/shadow` files. 

## 6. Account Lockout Mechanisms
- Configure account lockout policies that temporarily disable accounts after a certain number of failed login attempts


## Structure of `/etc/shadow`

Each line in the `/etc/shadow` file corresponds to a user account and contains multiple fields separated by colons (`:`)

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

- **`*`**: Account locked out
- **`!`**: Single exclamation means ssh will work but password will not
- **`!!`**: Double exclamation means account created but no password set.

#### Commands for Managing `/etc/shadow`

- **`passwd`**: Change a user's password.
- **`chage`**: Change the password aging information.
- **`vipw -s`**: Safely edit the `/etc/shadow` file (locks the file during editing, similar to `visudo` for `/etc/sudoers`).
