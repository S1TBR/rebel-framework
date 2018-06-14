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
echo -e "$white"
bash update.sh
echo -e "${arr[0]}"

rebel_console(){
   if [[ $1 == 'use' ]] ; then
      if [[ $2 =~ 'net' ]] ; then
         cd ../net
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ../tab
      elif [[ $2 =~ ^'info' ]] ; then
         cd ../info
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ../tab
      elif [[ $2 =~ ^'web' ]] ; then
         cd ../web
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ../tab
      elif [[ $2 =~ ^'torrent' ]] ; then
         cd ../torrent
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ../tab
     elif [[ $2 =~ ^'com' ]] ; then
         cd ../com
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ../tab
     elif [[ $2 =~ ^'crypto' ]] ; then
         cd ../crypto
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ../tab
     elif [[ $2 =~ ^'phish' ]] ; then
         cd ../phish
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ../tab
     elif [[ $2 =~ ^'re' ]] ; then
         cd ../re
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ../tab  
     elif [[ $2 =~ ^'df' ]] ; then
         cd ../df
         bash controller.sh $2 $3 $4 $5 $6 $7 $8 $9 ${10}
         cd ../tab                  
      else
         echo -e "${purp}[-] Invalid parameter use show 'help' for more information"
      fi
   elif [[ $1 == "show" ]] ; then
      if [[ $2 == "modules" ]] ; then
          bash ../print_help_modules.sh modules
      elif [[ $2 == "help" ]] ; then
          bash ../print_help_modules.sh help
      else
         echo -e "${purp}[-] Invalid parameter use show 'help' for more information"
      fi
   elif [[ $1 == "help" ]] || [[ $1 == "?" ]] ; then
       bash ../print_help_modules.sh help 
   elif [[ $1 == 'quit' ]] || [[ $1 == 'exit' ]] ; then
       exit 0
   elif [[ $1 == "banner" ]] ; then
       rand="$[ $RANDOM % 6 ]"
       color="${arr[$rand]}" # select random color
       echo -e $color
       python ../print_banner.py
   elif [[ $1 == "clear" ]] || [[ $1 == "reset" ]] ; then
       reset
   elif [[ $1 == '!' ]] && [[ $( which $2 ) != "" ]] ; then
       bash -c "$2 $3 $4 $5 $6 $7 $8 $9 ${10}"
   elif [[ $1 == "" ]] ; then
        :        
   else
      echo -e "${purp}[-] Invalid parameter use show 'help' for more information"
   fi
}

cd tab
while IFS= read -e -p "$( echo -e $white ; echo -e ${grayterm}{REBEL}➤~#${normal} ) " option; do
   history -s "$option"
   rebel_console $option
done
