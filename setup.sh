#!/bin/bash

arr[0]='\e[1;94m' ; blue=${arr[0]}
arr[1]='\e[1;31m' ; red=${arr[1]}
arr[2]='\e[1;33m' ; yellow=${arr[2]}
arr[3]='\e[1;35m' ; purp=${arr[3]}
arr[4]='\e[1;32m' ; green=${arr[4]}
arr[5]='\e[97m'   ; white=${arr[5]}
grayterm='\e[1;40m'

if [[ $( whoami ) != "root" ]] ; then
   echo "[X] need root access"
   exit
fi

sudo apt-get update
net_setup(){
   cd modules/net/
   apt-get install dsniff etherape nmap ettercap-graphical iptraf-ng driftnet tshark tcpdump sslstrip -y
   apt-get install debhelper cmake bison flex libgtk2.0-dev libltdl3-dev libncurses-dev libncurses5-dev libpcap-dev libpcre3-dev libssl-dev libcurl4-openssl-dev ghostscript -y
   apt-get install arp-scan -y
   cd sslstrip2
   python setup.py install
   cd ..
   chmod +x respoof.sh main.sh
   cd ..
}

web_setup(){
   cd modules/web

}
info_setup(){
   sudo apt-get install -y perl
   cpan install JSON

}

com_setup(){
   pip3 install termchat
   pip3 install qrcode
}

torrent_setup(){
   pip3 install pirate-get
   apt-get install aria2 -y
}

phishing_setup(){
   pip install wget==3.2
   apt-get install php-common libapache2-mod-php php-cli -y
   cd phish/Server
   if [[ $( arch ) == "x86_64" ]] ; then
      wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
   else
      wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip
   fi
   unzip ngrok-stable-linux-*
   rm -rf ngrok-stable-linux-*
}

net_setup
info_setup
com_setup
torrent_setup
phishing_setup

reset
rand="$[ $RANDOM % 6 ]"
color="${arr[$rand]}" # select random color
echo -en $color
python print_banner.py



