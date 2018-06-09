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

if [[ $module != "site" ]] && [[ $module != "phone" ]] && [[ $module != "server" ]] && [[ $module != "whois" ]] && [[ $module != "loc" ]] && [[ $module != "bcf" ]] && [[ $module != "subdomain" ]] && [[ $module != "email" ]] ; then
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

if [[ $module == "email" ]] ; then
	target="test@gmail.com [email@blabla.com/emails.txt]"   
else 
    if [[ $module == "phone" ]] ; then
	   target="201061031555"
	else 
	   target="google.com"
	fi
fi  
while IFS= read -e -p "$( echo -e $white ; echo -e ${grayterm}{REBEL}➤[${white}$1]~#${normal} ) " cmd1 ; do
    history -s "$cmd1"
    if [[ ${1} =~ 'info/' ]] ; then 
	      if [[ $( echo $cmd1 | cut -d " " -f 1 )  == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              echo '  Option                                   Value'
	            echo '  ======                                   ====='
	            echo "  target                                   $target"
	            echo	          
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi               
        elif [[ $( echo $cmd1 | cut -d " " -f 1 )  == 'set' ]] ; then
	         if [[ $( echo $cmd1 | cut -d " " -f 2 )  == 'target' ]] ; then
              target="$( echo $cmd1 | cut -d " " -f 3- ) "
           fi
        elif [[ $( echo $cmd1 | cut -d " " -f 1 )  == 'run' ]] ; then
           if [[ $module == "site" ]] ; then
              echo -e "01\n$target\n" | perl main.pl
           elif [[ $module == "phone" ]] ; then
              echo -e "02\n$target\n" | perl main.pl
           elif [[ $module == "server" ]] ; then
              echo -e "03\n$target\n" | perl main.pl
           elif [[ $module == "whois" ]] ; then
              echo -e "04\n$target\n" | perl main.pl
           elif [[ $module == "loc" ]] ; then
              echo -e "05\n$target\n" | perl main.pl
           elif [[ $module == "bcf" ]] ; then
              echo -e "06\n$target\n" | perl main.pl
           elif [[ $module == "subdomain" ]] ; then
              echo -e "11\n$target\n" | perl main.pl
           elif [[ $module == "email" ]] ; then
           	  if [[ -f $target ]] ; then
                 for i in $(cat $target); do
                     echo -e "12\n$i\n" | perl main.pl
                  done
              elif ! [[ $target =~ '@' ]] ; then
                 	echo -e "${red} [X] email format is not valid or email list couldn't be located"
              else	
                    echo -e "12\n$target\n" | perl main.pl
              fi
           fi      
        else
           misc $cmd1
        fi                                                                                                                          
    fi   
done
