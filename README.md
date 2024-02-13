# cmespray
Password spray Active Directory accounts with [crackmapexec](https://github.com/byt3bl33d3r/CrackMapExec) according to reset counter and lockout threshold policies. Modified to use flags instead of prompt for input. Now has options for protocol and port.

### Usage
```
┌──(root㉿kali)-[/home/kali/]
└─# bash ../cmespray/cmespray-2.sh -t 10.0.1.10 -m smb -u ./test-users.txt -p ./test-pass.txt -l 3 -r 4 -n 445 
[*] Trying 2 passwords every 5 minutes against 10.0.1.10 and using ./test-pass.txt and ./test-users.txt lists.
```
