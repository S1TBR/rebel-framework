#!/bin/bash

normal='\e[0m'
blue='\e[1;94m'
red='\e[1;31m'
yellow='\e[1;33m'
ul='\e[1;4m'
purp='\e[1;35m'
green='\e[1;32m'
white='\e[97m'
grayterm='\e[1;40m'
target='192.168.1.1/24'
interface='wlan0'
gateway="192.168.1.1"
ports="-"
check="off"
driftnet="off"
urlsnarf="off"
silnet="on"
tshark="off"
ettercap="on"
tcpdump="off"
tsharkX="off"
burp="off"
ssllog="ssl.log"
dnsspoof="off"
dnsspoofison="off"
jsfile="off"
jsfileison="off"
jsurl="off"
jsurlison="off"
jskeylog="on"
while true ; do
    ######################################################################################
    echo -e "$white"
    if [[ ${1} == 'net/map' ]] ; then
        echo -en "${grayterm}{REBEL}➤[${white}net/map]~#${normal} " ; read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8
	      if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
        echo '  Option                                   Value'
	      echo '  ======                                   ====='
        echo "  target                                   $target  [192.168.1.1/24,192.168.1.1,192.168.1.3,etc..]"
	      echo "  interface                                $interface"
	      echo
        elif [[ $cmd1 == 'set' ]] ; then
	         if [[ $cmd2 == 'target' ]] ; then
              target=$cmd3
	      elif [[ $cmd2 == 'interface' ]] ; then
              interface=$cmd3
	      fi
        elif [[ $cmd1 == 'run' ]] ; then
           ./main.sh -i $interface -t $target --map-lan -sn
        elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
            cd .. ; break
        elif [[ $cmd1 == '!' ]];then
           $cmd2             
        fi
    ######################################################################################
    elif [[ ${1} == 'net/iface' ]] ; then
        echo -en "${grayterm}{REBEL}➤[${white}net/iface]~#${normal} " ; read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8
        if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
          echo '  Option                                   Value'
          echo '  ======                                   ====='
          echo "  interface                                all [static value]"
          echo
        elif [[ $cmd1 == 'run' ]] ; then
           ./main.sh -I
        elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
            cd .. ; break
        elif [[ $cmd1 == '!' ]];then
           $cmd2             
        fi
    ######################################################################################
    elif [[ ${1} == 'net/scan' ]] ; then
        echo -en "${grayterm}{REBEL}➤[${white}net/scan]~#${normal} " ; read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8
        fscan="on"
        gscan="off"
        if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
          echo '  Option                                   Value'
          echo '  ======                                   ====='
          echo "  target                                   $target  [192.168.1.1/24,192.168.1.1,192.168.1.3,etc..]"
          echo "  interface                                $interface"
          echo -e "  fscan                                    $fscan \t [ fast scan ]"
          echo -e "  gscan                                    $gscan \t [ aggressive scan ]"
          echo ""
        elif [[ $cmd1 == "set" ]] ; then
           if [[ $cmd2 == 'target' ]] ; then
              target=$cmd3
           elif [[ $cmd2 == 'interface' ]] ; then
              interface=$cmd3
           elif [[ $cmd2 == 'fscan' ]] ; then
              fscan=$"cmd3"
              if [[ $fscan == "on" ]] ; then
                gscan="off"
              fi
           elif [[ $cmd2 == 'gscan' ]] ; then
              gscan=$cmd3
              if [[ $gscan == "on" ]] ; then
                fscan="off"
              fi
           fi
       elif [[ $cmd1 == 'run' ]] ; then
          if [[ $fscan == "on" ]] ; then
             ./main.sh -i $interface -t $target --map-lan -F
          else
             ./main.sh -i $interface -t $target --map-lan -A -sV -p-
          fi
       elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
           cd .. ; break
       elif [[ $cmd1 == '!' ]];then
           $cmd2            
       fi
    ######################################################################################
    elif [[ ${1} == "net/vuln" ]] ; then
        echo -en "${grayterm}{REBEL}➤[${white}net/vuln]~#${normal} " ; read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8
        if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
        echo '  Option                                   Value'
        echo '  ======                                   ====='
        echo "  target                                   $target  [192.168.1.1/24,192.168.1.1,192.168.1.3,etc..]"
        echo "  interface                                $interface"
        echo "  ports                                    $ports [ - (all) | 20-1000 | 80,443,445-1000 ]"
        echo
        elif [[ $cmd1 == 'run' ]] ; then
           ./main.sh -i $interface -t $target --map-lan --script vuln -p $ports
        elif [[ $cmd1 == "set" ]] ; then
           if [[ $cmd2 == 'target' ]] ; then
              target=$cmd3
           elif [[ $cmd2 == 'interface' ]] ; then
              interface=$cmd3
           elif [[ $cmd2 == 'ports' ]] || [[ $cmd2 == "port" ]] ; then
              ports=$cmd3
           fi
        elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
           cd .. ; break
        elif [[ $cmd1 == '!' ]];then
           $cmd2    
        fi
    ######################################################################################
    elif [[ ${1} == "net/cut" ]] ; then
        echo -en "${grayterm}{REBEL}➤[${white}net/cut]~#${normal} " ; read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8
        if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
        echo '  Option                                   Value'
        echo '  ======                                   ====='
        echo "  target                                   $target  [192.168.1.1/24,192.168.1.1,192.168.1.3,etc..]"
        echo "  gateway                                  $gateway "
        echo "  interface                                $interface"
        echo "  no-check                                 $check (on/OFF) [Check if targets are reachable]"
        echo "  silent                                   $silnet [run arpspoof]"

        elif [[ $cmd1 == "set" ]] ; then
           if [[ $cmd2 == 'target' ]] ; then
              target=$cmd3
           elif [[ $cmd2 == 'interface' ]] ; then
              interface=$cmd3
           elif [[ $cmd2 == 'no-check' ]] ; then
              check=$cmd3
           elif [[ $cmd2 == "silent" ]] ; then
              silnet=$cmd3
           elif [[ $cmd2 == "gateway" ]] ; then
               gateway=$cmd3
           fi
        elif [[ $cmd1 == 'run' ]] ; then
           if [[ $silnet == "on" ]] ; then
              if [[ $check == "on" ]] ; then
                 ./main.sh ./tornado.sh -i $interface -t $target -g $gateway -f --no-check --silent
              else
                 ./main.sh ./tornado.sh -i $interface -t $target -g $gateway -f --silent
              fi
           else
              if [[ $check == "on" ]] ; then
                 ./main.sh ./tornado.sh -i $interface -t $target -g $gateway -f --no-check
              else
                 ./main.sh ./tornado.sh -i $interface -t $target -g $gateway -f
              fi
           fi
        elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
            cd .. ; break
        elif [[ $cmd1 == '!' ]];then
           $cmd2             
        fi
    ######################################################################################
    elif [[ ${1} == "net/sslsniff" ]] || [[ ${1} == "net/sniff" ]]; then
        if [[ ${1} == "net/sniff" ]] ; then
           echo -en "${grayterm}{REBEL}➤[${white}net/sniff]~#${normal} "
        else
           echo -en "${grayterm}{REBEL}➤[${white}net/sslsniff]~#${normal} "
        fi
        read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8
        if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
           echo '  Option                                   Value'
           echo '  ======                                   ====='
           echo -e "  target                                   $target"
           echo -e "  interface                                $interface"
           echo -e "  gateway                                  $gateway "
           echo -e "  no-check                                 $check\t[Check if targets are reachable]"
           echo -e "  driftnet                                 $driftnet\t[enable driftnet to extract images from session pcap file]"
           echo -e "  urlsnarf                                 $urlsnarf\t[log GET/POST requests with urlsnarf]"
           echo -e "  silent                                   $silnet\t[run arpspoof and dns2proxy in background]"
           echo -e "  tshark                                   $tshark\t[capture detailed post requests info with tshark]"
           echo -e "  ettercap                                 $ettercap\t[capture post requests with ettercap]"
           echo -e "  tcpdump                                  $tcpdump\t[capture post requests with TCPdump]"
           echo -e "  tsharkX                                  $tsharkX\t[capture GET/POST requests headers with tshark]"
           if [[ ${1} == "net/sniff" ]] ; then
              echo -e "  burp                                     $burp [intercept captured traffic with burpsuite]"
              echo -e "  dnsspoof                                 $dnsspoof [DNS spoofing with dns2proxy, FILE([DOMAIN FAKE_IP])]"
           else
              echo -e "  ssllog                                   $ssllog [ssl traffic log file name]"
           fi
        elif [[ $cmd1 == "set" ]] ; then
           if [[ $cmd2 == 'target' ]] ; then
              target=$cmd3
           elif [[ $cmd2 == "gateway" ]] ; then
               gateway=$cmd3
           elif [[ $cmd2 == 'interface' ]] ; then
              interface=$cmd3
           elif [[ $cmd2 == 'no-check' ]] ; then
              check=$cmd3
           elif [[ $cmd2 == "driftnet" ]] ; then
              driftnet=$cmd3
           elif [[ $cmd2 == "urlsnarf" ]] ; then
              urlsnarf=$cmd3
           elif [[ $cmd2 == "tshark" ]] ; then
              tshark=$cmd3
           elif [[ $cmd2 == "silent" ]] ; then
              silnet=$cmd3
           elif [[ $cmd2 == "ettercap" ]] ; then
              ettercap=$cmd3
           elif [[ $cmd2 == "tcpdump" ]] ; then
              tcpdump=$cmd3
           elif [[ $cmd2 == "tsharkX" ]] || [[ $cmd2 == "tsharkx" ]] ; then
              tsharkX=$cmd3
           elif [[ $cmd2 == "ssllog" ]] ; then
              ssllog=$cmd3
           elif [[ $cmd2 == "burp" ]] ; then
              burp=$cmd3
              if [[ $cmd3 == "on" ]] ; then
                  dnsspoof="off"
                  dnsspoofison="off"
              fi
           elif [[ $cmd2 == "dnsspoof" ]] ; then
              dnsspoof=$cmd3
              dnsspoofison="on"
              if [[ $cmd3 != "off" ]] ; then
                 burp="off"
              fi
           fi
        elif [[ $cmd1 == 'run' ]] ; then
           options=""
           if [[ ${1} == "net/sniff" ]] ; then
               vars=$(echo "--no-check=$check -d=$driftnet --urlsnarf=$urlsnarf --silent=$silnet --tshark=$tshark --ettercap=$ettercap --tcpdump=$tcpdump --tskark+=$tsharkX --burp=$burp --dnsspoof=$dnsspoofison")
           else
               vars=$(echo "--no-check=$check -d=$driftnet --urlsnarf=$urlsnarf --silent=$silnet --tshark=$tshark --ettercap=$ettercap --tcpdump=$tcpdump --tskark+=$tsharkX")
           fi    
           counter=1
           for i in $(seq 1 11) ; do
               if [[ $( echo $vars | tr ' ' '\n' | awk NR==${counter} | cut -d "=" -f 2 ) == "on" ]] ; then
                  options="$options $( echo $vars | tr ' ' '\n' | awk NR==${counter} | cut -d '=' -f 1 )"
               fi
               let counter+=1
           done
            options=$( echo $options | tr '\n' ' ' )
           if [[ ${1} == "net/sniff" ]] ; then
              if [[ $dnsspoof != "off" ]] ; then 
                 ./main.sh ./tornado.sh -i $interface -t $target -g $gateway $options $dnsspoof
              else
                 ./main.sh ./tornado.sh -i $interface -t $target -g $gateway $options
              fi
           else
              ./main.sh ./tornado.sh -i $interface -t $target -g $gateway --hsts -o $ssllog $options
           fi
        elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
            cd .. ; break
        elif [[ $cmd1 == '!' ]];then
           $cmd2
        fi
    ######################################################################################
    fi
done
