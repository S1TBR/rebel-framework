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

rebel_console(){

   if [[ $1 == 'use' ]] ; then
      if [[ $2 =~ 'net' ]] ; then
         cd net
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ..
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

