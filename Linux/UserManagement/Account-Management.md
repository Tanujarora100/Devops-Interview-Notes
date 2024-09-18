### Set expired date for account
```bash 
sudo chage -E 2030-03-01 jane
#Verify it 
sudo chage --list
jane
```
### Create system account
```bash
sudo useradd --system user
```
### Account never expires
```bash
bob@ubuntu-host ~ ✖ sudo chage -E -1 jane

bob@ubuntu-host ~ ➜  sudo chage -l jane
Last password change                                    : never
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 99999
Number of days of warning before password expires       : 7

bob@ubuntu-host ~ ➜  
```
### Force someone to change password on login
```bash
bob@ubuntu-host ~ ➜  sudo chage --lastday 0 jane

bob@ubuntu-host ~ ➜  sudo chage -l jane
Last password change                                    : password must be changed
Password expires                                        : password must be changed
Password inactive                                       : password must be changed
Account expires                                         : never
Minimum number of days between password change          : 0
Maximum number of days between password change          : 0
Number of days of warning before password expires       : 7
```
### How to rename a group
```bash
bob@ubuntu-host ~ ✖ sudo groupmod --new-name soccer cricket
```
### Create user with a specific UID
```bash
bob@ubuntu-host ~ ➜  sudo useradd sam --uid 5322 && sudo usermod -aG soccer sam
```
### Change primary group of user
```bash
#Use usermod -g command
bob@ubuntu-host ~ ✖ sudo usermod -g rugby sam  
```
### Give warning messages to user before password expiry
```bash
# use --warndays flag
bob@ubuntu-host ~ ✖ sudo chage --warndays 2 jane

```