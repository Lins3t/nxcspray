# nxcspray
Password spraying with [netexec](https://github.com/Pennyw0rth/NetExec) according to reset counter and lockout threshold policies. 
### Usage
```
flags:
-t: Target IP address or hostname
-m: Method/Protocol - any protocol netexec supports (SMB, LDAP, RDP, etc.)
-u: Username or username file
-p: Password or password file
-l: Number of passwords to be tested per delay cycle
-r: Delay between unique passwords, in minutes
-d: Domain - optional (uses target's default domain otherwise)
-n: 'Custom port number - optional
-h: 'Print this help summary page

Usage example:
bash ./nxcspray.sh -t 10.1.1.1 -m smb -u ./users.txt -p ./passwords.txt -a 5 -i 30 -d test.local -n 445
```
