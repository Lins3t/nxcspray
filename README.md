# nxcspray
Password spray Active Directory accounts with [netexec](https://github.com/Pennyw0rth/NetExec) according to reset counter and lockout threshold policies. 
### Usage
```
┌──(root㉿kali)-[/home/kali/]
└─# bash ../nxcspray/nxcspray.sh -t 10.0.1.10 -m smb -u ./test-users.txt -p ./test-pass.txt -l 3 -r 4 -n 445 
[*] Trying 2 passwords every 5 minutes against 10.0.1.10 and using ./test-pass.txt and ./test-users.txt lists.
```
