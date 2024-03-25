# nxcspray
Password spraying with [netexec](https://github.com/Pennyw0rth/NetExec) according to reset counter and lockout threshold policies. 
### Usage
```
flags:
-t: Target IP address or hostname
-m: Method/Protocol - any protocol netexec can use (SMB, LDAP, RDP, etc.)
-u: Username or username file
-p: Password or password file
-l: Account Lockout Threshold' value
-r: 'Reset Account Lockout Counter After' value
-n: 'Custom port number - optional
-h: 'Print this help summary page

Usage example:
nxcspray.sh -t 10.1.1.1 -m smb -u ./users.txt -p ./passwords.txt -l 5 -r 30 -n 445


bash ../nxcspray/nxcspray.sh -t 10.0.1.10 -m smb -u ./test-users.txt -p ./test-pass.txt -l 3 -r 4 -n 445 
[*] Trying 2 passwords every 5 minutes against 10.0.1.10 and using ./test-pass.txt and ./test-users.txt lists.
```
