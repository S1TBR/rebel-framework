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
   apt-get install md5sum nc -y
   pip3 install qrcode
}

torrent_setup(){
   pip3 install pirate-get
   apt-get install aria2c -y
}

phishing_setup(){
   pip install wget==3.2
   apt-get install php-common libapache2-mod-php php-cli -y
}

net_setup
info_setup
com_setup
torrent_setup
cd .. ; reset ; python print_banner.py



