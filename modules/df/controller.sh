#!/bin/bash

normal='\e[0m'
arr[0]='\e[1;94m' ; blue=${arr[0]}
arr[1]='\e[1;31m' ; red=${arr[1]}
arr[2]='\e[1;33m' ; yellow=${arr[2]}
arr[3]='\e[1;35m' ; purp=${arr[3]}
arr[4]='\e[1;32m' ; green=${arr[4]}
arr[5]='\e[97m'   ; white=${arr[5]}
grayterm='\e[1;40m'

module=$(echo $1 | cut -d '/' -f 2 )

if [[ $module != "entropy" ]] && [[ $module != "recover" ]] && [[ $module != "scan" ]] ; then
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
        bash ../../print_help_modules.sh help 
    elif [[ $1 == "banner" ]] ; then
        rand="$[ $RANDOM % 6 ]"
        color="${arr[$rand]}" # select random color
        echo -e $color
        python ../../print_banner.py  
    elif [[ $1 == "" ]] ; then
        :               
    else
       echo -e "${purp}[-] Invalid parameter use show 'help' for more information"         
    fi    
}

file="nul"
threads="2"

while IFS= read -e -p "$( echo -e $white ; echo -e ${grayterm}{REBEL}➤[${white}$1]~#${normal} ) " cmd1 ; do
    history -s "$cmd1"
    if [[ ${1} =~ 'df/' ]] ; then
      if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
          {
            echo -e "  Option\t\t\t\t|Value"
            echo -e "  ======\t\t\t\t|====="
            echo -e "  file\t\t\t\t|$file"
            if [[ $module == "scan" ]] ; then 
               echo -e "  threads\t\t\t\t|$threads"
            fi
          } | column -t -s "|"
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
          bash ../../print_help_modules.sh modules
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
          bash ../../print_help_modules.sh help
        fi                 
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
          if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'file' ]] ; then
             file=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g")
          elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "threads" ]] ; then 
             threads=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g")
          fi    
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
         if [[ -f $file ]] ; then
            if [[ $module == "entropy" ]] ; then
                binwalk -E $file | while read line ; do echo -e "${red}[+]${normal} $line" ; done
            elif [[ $module == "recover" ]] ; then
                binwalk -Mr --dd='.*' $file | while read line ; do echo -e "${red}[+]${normal} $line" ; done
                mv _${file}* /tmp/
                echo -e "[*] "    
            elif [[ $module == "scan" ]] ; then
                bulk_extractor -e all -j $threads $file -o /tmp/${file}_output | while read line ; do echo "[+] $line" | grep -ve '\*' -e bulk ; done   
            fi
         else
            echo "${red}[x] File not found !"                          
         fi 
      else
         misc $cmd1
      fi
    fi  
done                              
