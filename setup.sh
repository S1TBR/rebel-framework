#!/bin/bash

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
   git clone https://github.com/LeonardoNve/dns2proxy
   git clone https://github.com/byt3bl33d3r/sslstrip2
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


net_setup
info_setup
cd .. ; reset ; python print_banner.py
