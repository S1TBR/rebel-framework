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
if [[ $1 =~ "search" ]] ; then
   target="linux mint"
else
   target="file.torrent"
fi      
speed="nolimit"
while true ; do
    echo -e "$white"	
    if [[ ${1} == 'torrent/search' ]] ; then 
           echo -en "${grayterm}{REBEL}➤[${white}torrent/search]~#${normal} "
           read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8 cmd9 $cmd10 $cmd11 $cmd12
	       if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
              echo '  Option                                   Value'
	          echo '  ======                                   ====='
	          echo "  target                                   $target"
	          echo	          
           elif [[ $cmd1 == 'set' ]] ; then
	            if [[ $cmd2 == 'target' ]] ; then
                   target="$cmd3 $cmd4 $cmd5 $cmd6 $cmd7 $cmd8 $cmd9 $cmd10 $cmd11 $cmd12"
                fi
           elif [[ $cmd1 == 'run' ]] ; then
                pirate-get $target
           elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
               cd .. ; break
           elif [[ $cmd1 == '!' ]];then
              $cmd2             
           fi
    elif [[ ${1} == 'torrent/get' ]] ; then 
           echo -en "${grayterm}{REBEL}➤[${white}torrent/get]~#${normal} "
           read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8 cmd9 $cmd10 $cmd11 $cmd12
	       if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
              echo '  Option                                   Value'
	          echo '  ======                                   ====='
	          echo "  target                                   $target"
              echo "  max-speed                                $speed [ex.500KB,2M]"
	          echo	          
           elif [[ $cmd1 == 'set' ]] ; then
	            if [[ $cmd2 == 'target' ]] ; then
                   target="$cmd3 $cmd4 $cmd5 $cmd6 $cmd7 $cmd8 $cmd9 $cmd10 $cmd11 $cmd12"
                elif [[ $cmd2 == "max-speed" ]] ; then
                   if [[ $cmd3 != "nolimit" ]] ; then
                   	   speed="--max-download-limit=$cmd3"
                   else
                       speed=""	   
                   fi    
                fi
           elif [[ $cmd1 == 'run' ]] ; then
                aria2c -T $target -c $speed
           elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
               cd .. ; break
           elif [[ $cmd1 == '!' ]];then
              $cmd2             
           fi
    else
        break
    fi           
done