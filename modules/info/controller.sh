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
module=$(echo $1 | cut -d '/' -f 2 )
check="site phone server whois loc bcf subdomain email"

if [[ $module == "email" ]] ; then
	target="test@gmail.com [email@blabla.com/emails.txt]"   
else 
    if [[ $module == "phone" ]] ; then
	   target="201061031555"
	else 
	   target="google.com"
	fi
fi  
while true ; do
    echo -e "$white"	
    if [[ ${1} =~ 'info/' ]] ; then 
        if [[ $(echo $check | grep -wo "$module" ) != "" ]] ; then
           echo -en "${grayterm}{REBEL}➤[${white}info/$module]~#${normal} "
           read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8

	       if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
              echo '  Option                                   Value'
	          echo '  ======                                   ====='
	          echo "  target                                   $target"
	          echo	          
           elif [[ $cmd1 == 'set' ]] ; then
	            if [[ $cmd2 == 'target' ]] ; then
                target=$cmd3
                fi
           elif [[ $cmd1 == 'run' ]] ; then
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
           elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
               cd .. ; break
           elif [[ $cmd1 == '!' ]];then
              $cmd2             
           fi
        fi
    else
       break
    fi       
done
