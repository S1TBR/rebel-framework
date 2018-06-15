#!/bin/bash

normal='\e[0m'
arr[0]='\e[1;94m' ; blue=${arr[0]}
arr[1]='\e[1;31m' ; red=${arr[1]}
arr[2]='\e[1;33m' ; yellow=${arr[2]}
arr[3]='\e[1;35m' ; purp=${arr[3]}
arr[4]='\e[1;32m' ; green=${arr[4]}
arr[5]='\e[97m'   ; white=${arr[5]}
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
fscan="on"
gscan="off"

module=$(echo $1 | cut -d '/' -f 2 )
if [[ $module != "iface" ]] && [[ $module != "map" ]] && [[ $module != "scan" ]] && [[ $module != "vuln" ]] && [[ $module != "sniff" ]] && [[ $module != "sslsniff" ]] && [[ $module != "cut" ]] ; then
   echo -e "${red}[x] Wrong module name"
   exit
fi   

misc(){
    if [[ $1 == "back" ]] || [[ $1 == "exit" ]] || [[ $1 == "quit" ]] ; then
        exit
    elif [[ $1 == '!' ]] ; then
        $2
    elif [[ $1 == "clear" ]] || [[ $1 == "reset" ]] ; then
        clear   
    elif [[ $1 == "help" ]] || [[ $1 == "?" ]] ; then
        bash ../print_help_modules.sh help 
    elif [[ $1 == "banner" ]] ; then
        rand="$[ $RANDOM % 6 ]"
        color="${arr[$rand]}" # select random color
        echo -e $color
        python ../print_banner.py   
    elif [[ $1 == "" ]] ; then
        :         
    else
       echo -e "${purp}[-] Invalid parameter use show 'help' for more information"         
    fi    
}

while IFS= read -e -p "$( echo -e $white ; echo -e ${grayterm}{REBEL}➤[${white}$1]~#${normal} ) " cmd1 ; do
    history -s "$cmd1"
    if [[ ${1} == 'net/map' ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              echo '  Option                                   Value'
	            echo '  ======                                   ====='
              echo "  target                                   $target  [192.168.1.1/24,192.168.1.1,192.168.1.3,etc..]"
	            echo "  interface                                $interface"
	            echo
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi                
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
	         if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
              target=$( echo $cmd1 | cut -d " " -f 3- )
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'interface' ]] ; then
              interface=$( echo $cmd1 | cut -d " " -f 3- )
	      fi
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
           bash main.sh -i $interface -t $target --map-lan -sn
        else
              misc $cmd1            
        fi
    ######################################################################################
    elif [[ ${1} == 'net/iface' ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              echo '  Option                                   Value'
              echo '  ======                                   ====='
              echo "  interface                                all [static value]"
              echo
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi               
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
           bash main.sh -I
        else
              misc $cmd1           
        fi
    ######################################################################################
    elif [[ ${1} == 'net/scan' ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              echo '  Option                                   Value'
              echo '  ======                                   ====='
              echo "  target                                   $target  [192.168.1.1/24,192.168.1.1,192.168.1.3,etc..]"
              echo "  interface                                $interface"
              echo -e "  fscan                                    $fscan \t [ fast scan ]"
              echo -e "  gscan                                    $gscan \t [ aggressive scan ]"
              echo ""
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi           
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "set" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
              target=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'interface' ]] ; then
              interface=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'fscan' ]] ; then
              fscan=$"cmd3"
              if [[ $fscan == "on" ]] ; then
                gscan="off"
              fi
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'gscan' ]] ; then
              gscan=$( echo $cmd1 | cut -d " " -f 3- )
              if [[ $gscan == "on" ]] ; then
                fscan="off"
              fi
           fi
       elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
          if [[ $fscan == "on" ]] ; then
             bash main.sh -i $interface -t $target --map-lan -F
          else
             bash main.sh -i $interface -t $target --map-lan -A -sV -p-
          fi
       else
              misc $cmd1          
       fi
    ######################################################################################
    elif [[ ${1} == "net/vuln" ]] ; then                
        if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              echo '  Option                                   Value'
              echo '  ======                                   ====='
              echo "  target                                   $target  [192.168.1.1/24,192.168.1.1,192.168.1.3,etc..]"
              echo "  interface                                $interface"
              echo "  ports                                    $ports [ - (all) | 20-1000 | 80,443,445-1000 ]"
              echo          
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi        
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
           bash main.sh -i $interface -t $target --map-lan --script vuln -p $ports
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "set" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
              target=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'interface' ]] ; then
              interface=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'ports' ]] || [[ $( echo $cmd1 | cut -d " " -f 2 ) == "port" ]] ; then
              ports=$( echo $cmd1 | cut -d " " -f 3- )
           fi
        else
              misc $cmd1
        fi
    ######################################################################################
    elif [[ ${1} == "net/cut" ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              echo '  Option                                   Value'
              echo '  ======                                   ====='
              echo "  target                                   $target  [192.168.1.1/24,192.168.1.1,192.168.1.3,etc..]"
              echo "  gateway                                  $gateway "
              echo "  interface                                $interface"
              echo "  no-check                                 $check (on/OFF) [Check if targets are reachable]"
              echo "  silent                                   $silnet [run arpspoof]"       
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi   
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "set" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
              target=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'interface' ]] ; then
              interface=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'no-check' ]] ; then
              check=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "silent" ]] ; then
              silnet=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "gateway" ]] ; then
               gateway=$( echo $cmd1 | cut -d " " -f 3- )
           fi
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
           if [[ $silnet == "on" ]] ; then
              if [[ $check == "on" ]] ; then
                 bash main.sh -i $interface -t $target -g $gateway -f --no-check --silent
              else
                 bash main.sh -i $interface -t $target -g $gateway -f --silent
              fi
           else
              if [[ $check == "on" ]] ; then
                 bash main.sh ./tornado.sh -i $interface -t $target -g $gateway -f --no-check
              else
                 bash main.sh ./tornado.sh -i $interface -t $target -g $gateway -f
              fi
           fi
        else
              misc $cmd1            
        fi
    ######################################################################################
    elif [[ ${1} == "net/sslsniff" ]] || [[ ${1} == "net/sniff" ]]; then
       if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
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
                 echo -e "  burp                                     $burp\t[intercept captured traffic with burpsuite]"
                echo -e "  dnsspoof                                 $dnsspoof\t[DNS spoofing with dns2proxy, FILE([DOMAIN FAKE_IP])]"
              else
                 echo -e "  ssllog                                   $ssllog\t[ssl traffic log file name]"
              fi           
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi             
       elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "set" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
              target=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "gateway" ]] ; then
               gateway=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'interface' ]] ; then
              interface=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'no-check' ]] ; then
              check=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "driftnet" ]] ; then
              driftnet=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "urlsnarf" ]] ; then
              urlsnarf=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "tshark" ]] ; then
              tshark=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "silent" ]] ; then
              silnet=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "ettercap" ]] ; then
              ettercap=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "tcpdump" ]] ; then
              tcpdump=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "tsharkX" ]] || [[ $( echo $cmd1 | cut -d " " -f 2 ) == "tsharkx" ]] ; then
              tsharkX=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "ssllog" ]] ; then
              ssllog=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "burp" ]] ; then
              burp=$( echo $cmd1 | cut -d " " -f 3- )
              if [[ $( echo $cmd1 | cut -d " " -f 3- ) == "on" ]] ; then
                  dnsspoof="off"
                  dnsspoofison="off"
              fi
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "dnsspoof" ]] ; then
              dnsspoof=$( echo $cmd1 | cut -d " " -f 3- )
              dnsspoofison="on"
              if [[ $( echo $cmd1 | cut -d " " -f 3- ) != "off" ]] ; then
                 burp="off"
              fi
           fi
       elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
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
                 bash main.sh ./tornado.sh -i $interface -t $target -g $gateway $options $dnsspoof
              else
                 bash main.sh ./tornado.sh -i $interface -t $target -g $gateway $options
              fi
           else
              bash main.sh ./tornado.sh -i $interface -t $target -g $gateway --hsts -o $ssllog $options
           fi
       else
              misc $cmd1
       fi
    fi  
done
