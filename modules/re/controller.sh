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

if [[ $module != "info" ]] && [[ $module != "trace" ]] && [[ $module != "elfdec" ]] ; then
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

file="/bin/ls"
cmd="/bin/ls -lah"
pid="nul"
function="main"
while IFS= read -e -p "$( echo -e $white ; echo -e ${grayterm}{REBEL}➤[${white}$1]~#${normal} ) " cmd1 ; do
    history -s "$cmd1"
    if [[ ${1} =~ 're/' ]] ; then
      if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
          {
          echo -e "  Option\t\t\t\t|Value"
            echo -e "  ======\t\t\t\t|====="
            if [[ $module == "trace" ]] ; then
               echo -e "  cmd\t\t\t\t|$cmd"
               echo -e "  pid\t\t\t\t|$pid"
            else
               echo -e "  file\t\t\t\t|$file"
               if [[ $module == "elfdec" ]] ; then
                  echo -e "  function\t\t\t\t|$function"
               fi   
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
          elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'cmd' ]] ; then
             cmd=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g" )
             pid="nul"
          elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'pid' ]] ; then
             pid=$( echo $cmd1 | cut -d " " -f 3- )
             cmd="nul"
          elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'function' ]] ; then
             function=$( echo $cmd1 | cut -d " " -f 3- )
          fi
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
        if [[ $module == "info" ]] ; then  
         if [[ -f $file ]] ; then
             echo -e "${purp}[*] INFORMATION ${normal}"
             rabin2 -I $file | while read line ; do echo -e "${red}[+]${normal} $line" ; done # executable information
             echo -e "${purp}[*] STRINGS ${normal} "
             rabin2 -z $file | while read line ; do echo -e "${red}[+]${normal} $line" ; done # strings
             echo -e "${purp}[*] DYNAMIC LIBRARIES {} ${normal}" 
             rabin2 -l $file | while read line ; do echo -e "${red}[+]${normal} $line" ; done # dynamic linked libraries
             echo -e "${purp}[*] FILE CHECKSUMS \$ ${normal}"
             rahash2 -a all $file  | while read line ; do echo -e "${red}[+]${normal} $line" ; done # file checksums 
             echo -e "${purp}[*] FUNCTION LIST {}"
             echo -e "functions \n exit " | plasma -i $file 2> /dev/null | grep -v "check the command analyzer to see the status" | while read line ; do echo -e "${red}[+]${normal} $line" ; done
         else
             echo "${red}[x] File not found !"                          
         fi
        elif [[ $module == "trace" ]] ; then
           if [[ $pid != "nul" ]] ; then
               ctrace -p "$pid"
           else
               ctrace -c "$cmd"           
           fi     
        elif [[ $module == "elfdec" ]] ; then
            plasma $file -x $function 2> /dev/null | grep -v "check the command analyzer to see the status"
        fi 
      else 
         misc $cmd1  
      fi
   fi
done    