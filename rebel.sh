#!/bin/bash
cd modules

# banner section
###################
normal='\e[0m'
arr[0]='\e[1;94m' ; blue=${arr[0]}
arr[1]='\e[1;31m' ; red=${arr[1]}
arr[2]='\e[1;33m' ; yellow=${arr[2]}
arr[3]='\e[1;35m' ; purp=${arr[3]}
arr[4]='\e[1;32m' ; green=${arr[4]}
arr[5]='\e[97m'   ; white=${arr[5]}
grayterm='\e[1;40m'

rand="$[ $RANDOM % 6 ]"
color="${arr[$rand]}" # select random color
echo -e $color
python print_banner.py  # print random banner
####################

# check if root
##############################################
if ! [[ $( whoami ) == "root" ]] ; then
	echo -e "${arr[2]}[X] Must Run As Root"
	exit
else
	sleep 0.5
	echo ""
fi
##############################################
echo -e "${arr[0]}"

print_modules(){
   echo -e "$red   ┬               ${yellow}Mod${red}ules"
   echo -e "$red   ├ "
   echo -e "$red   ├ $green net/iface       ${red}➤       ${white}Interface info."
   echo -e "$red   ├ $green net/map         ${red}➤       ${white}Hosts live Scan in LAN."
   echo -e "$red   ├ $green net/scan        ${red}➤       ${white}Scan [Ports, OS, Etc] IP."
   echo -e "$red   ├ $green net/vuln        ${red}➤       ${white}Scan for common vulnerabilities."
   echo -e "$red   ├ $green net/sniff       ${red}➤       ${white}Unencrypted traffic network sniffer and modifier."
   echo -e "$red   ├ $green net/sslsniff    ${red}➤       ${white}Sslstrip and sniff traffic."
   echo -e "$red   ├ $green net/cut         ${red}➤       ${white}Cut connection bettwen two points or more."
   echo -e "$red   ├ $green net/jsi         ${red}➤       ${white}"
   echo -e "$red   └"
   echo ""
}
print_help(){
   echo -e "$red   ┬                  ${yellow}H${red}elp"
   echo -e "$red   ├ "
   echo -e "$red   ├ $green show modules     ${red}➤     ${white}List all available modules"
   echo -e "$red   ├ $green use + <module>   ${red}➤     ${white}Use module"
   echo -e "$red   ├ $green show options     ${red}➤     ${white}Show module options"
   echo -e "$red   ├ $green banner           ${red}➤     ${white}Display an awesome rebel banner"
   echo -e "$red   ├ $green set              ${red}➤     ${white}Set a value to an option"
   echo -e "$red   ├ $green run              ${red}➤     ${white}Run module"
   echo -e "$red   ├ $green clear            ${red}➤     ${white}Clear screen"
   echo -e "$red   ├ $green back             ${red}➤     ${white}Back to the main"
   echo -e "$red   ├ $green exit - quit      ${red}➤     ${white}Exit from rebel"
   echo -e "$red   ├ $green ! <cmd(s)>       ${red}➤     ${white}Execute shell commands"
   echo -e "$red   ├ $green help - ?         ${red}➤     ${white}Show this message"
   echo -e "$red   └"
   echo ""

}
net(){
  cd net
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
               vars=$(echo "--no-check=$check --driftnet=$driftnet --urlsnarf=$urlsnarf --silent=$silnet --tshark=$tshark --ettercap=$ettercap --tcpdump=$tcpdump --tskark+=$tsharkX --burp=$burp --dnsspoof=$dnsspoofison")
           else
               vars=$(echo "--no-check=$check --driftnet=$driftnet --urlsnarf=$urlsnarf --silent=$silnet --tshark=$tshark --ettercap=$ettercap --tcpdump=$tcpdump --tskark+=$tsharkX")
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
        fi
    ######################################################################################
    elif [[ ${1} == "net/jsi" ]] ; then
        echo -en "${grayterm}{REBEL}➤[${white}net/jsi]~#${normal} " ; read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8
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
           echo -e "  jsfile                                   $jsfile\t[inject JS code from JS file (must be one line)] "
           echo -e "  jsurl                                    $jsurl\t[inject JS url in page content]                  "
           echo -e "  jskeylog                                 $jskeylog\t[inject JS keylogger]                            "

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
           elif [[ $cmd2 == "jsurl" ]] ; then
               jsurl=$cmd3
               if [[ $cmd3 != "off" ]] ; then
                  jsfile="off"
                  jsfileison="off"
                  jsurlison="on"
                  jskeylog="off"
               fi
           elif [[ $cmd2 == "jsfile" ]] ; then
               jsfile=$cmd3
               if [[ $cmd3 != "off" ]] ; then
                  jsurl="off"
                  jskeylog="off"
                  jsfileison="on"
                  jsurlison="off"
               fi
           elif [[ $cmd2 == "jskeylog" ]] ; then
               jskeylog=$cmd3
               if [[ $cmd3 != "off" ]] ; then
                  jsurl="off"
                  jsurlison="off"
                  jsfile="off"
                  jsfileison="off"
                  jskeylog="on"

               fi
           fi
        elif [[ $cmd1 == 'run' ]] ; then
            options=""      
            vars=$(echo "--no-check=$check --driftnet=$driftnet --urlsnarf=$urlsnarf --silent=$silnet --tshark=$tshark --ettercap=$ettercap --tcpdump=$tcpdump --tskark+=$tsharkX --js-url=$jsurlison --js-code=$jsfileison --js-keylogger=$jskeylog ")
            counter=1
            for i in $(seq 1 11) ; do
              if [[ $( echo $vars | tr ' ' '\n' | awk NR==${counter} | cut -d "=" -f 2 ) == "on" ]] ; then
                options="$options $( echo $vars | tr ' ' '\n' | awk NR==${counter} | cut -d '=' -f 1 )"
              fi
              let counter+=1
            done
            options=$( echo $options | tr '\n' ' ' )
            # make it possiable to do more than one enjection at the same session
            if [[ $jskeylog != "off" ]] ; then
                final_arg=$jskeylog
            elif [[ $jsfile != "off" ]]; then
                final_arg=$jsfile
            elif [[ $jsurl != "off" ]]; then
                final_arg=$jsurl
            fi    
            ./main.sh ./tornado.sh -i $interface -t $target -g $gateway $options $final_arg

        elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
           cd .. ; break
        fi

    fi
  done
}
rebel_console(){

   if [[ $1 == 'use' ]] ; then
      if [[ $2 =~ 'net' ]] ; then
         net $2
      else
         echo -e "${purp}[-] Invalid parameter use show 'help' for more information"
      fi
   elif [[ $1 == "show" ]] ; then
      if [[ $2 == "modules" ]] ; then
          print_modules
      elif [[ $2 == "help" ]] ; then
          print_help
      else
         echo -e "${purp}[-] Invalid parameter use show 'help' for more information"
      fi
   elif [[ $1 == "help" ]] || [[ $1 == "?" ]] ; then
       print_help
   elif [[ $1 == 'quit' ]] || [[ $1 == 'exit' ]] ; then
       exit 0
   elif [[ $1 == "banner" ]] ; then
       rand="$[ $RANDOM % 6 ]"
       color="${arr[$rand]}" # select random color
       echo -e $color
       python print_banner.py
   elif [[ $1 == "clear" ]] ; then
       reset
   elif [[ $1 == '!' ]] && [[ $( which $2 ) != "" ]] ; then
       $2 $3 $4 $5 $6 $7 $8 $9 ${10}
   else
      echo -e "${purp}[-] Invalid parameter use show 'help' for more information"
   fi
}

while true ; do
   echo -e "$white"
   echo -en "${grayterm}{REBEL}➤~#${normal} " ; read option arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 arg10
   rebel_console $option $arg1 $arg2 $arg3 $arg4 $arg5 $arg6 $arg7 $arg8 $arg9 $arg10
done
# list ==
# tornado
# brutex
# nmap
# white rappit
# dir search
# mdr1, hgrep, wshell
# sinper
# atscan
# hydra
# ctrace, radare2  scriptable tools
# unix-priv-sec check, lynis
# msfhelper
# nikto
# foremost binwalk volatilty bulk rkhunter
# android apk decompile and analysis
# wordpress exploiation framework & wpscan
# routersploit
# fluxion
# pcap file analysis and extractor

