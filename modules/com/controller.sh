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

nickname="rebellion"
room="rebel"
mode="send"
sender="autofind"
file="example.tar.gz"
while true ; do
    echo -e "$white"	
    if [[ ${1} == 'com/chat' ]] ; then 
           echo -en "${grayterm}{REBEL}➤[${white}com/chat]~#${normal} "
           read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8 cmd9 $cmd10 $cmd11 $cmd12
	       if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
              echo '  Option                                   Value'
	          echo '  ======                                   ====='
	          echo "  room                                     $room"
	          echo "  nickname                                 $nickname"
	          echo	          
           elif [[ $cmd1 == 'set' ]] ; then
	            if [[ $cmd2 == 'room' ]] ; then
                   room="$cmd3"
                elif [[ $cmd2 == "nickname" ]] ; then
                	nickname="$cmd3"
                fi	
           elif [[ $cmd1 == 'run' ]] ; then
                termchat -r $room -n $nickname
           elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
               cd .. ; break
           elif [[ $cmd1 == '!' ]];then
              $cmd3 $cmd4 $cmd5 $cmd6 $cmd7 $cmd8 $cmd9 $cmd10 $cmd11 $cmd12             
           fi                    
    elif [[ ${1} == "com/qrshare" ]] ; then
           echo -en "${grayterm}{REBEL}➤[${white}com/qrshare]~#${normal} "
           read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8 cmd9 $cmd10 $cmd11 $cmd12
	       if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
              echo '  Option                                   Value'
	          echo '  ======                                   ====='
	          echo "  file                                     $file" 
           elif [[ $cmd1 == 'set' ]] ; then
	            if [[ $cmd2 == 'file' ]] ; then
                   file=$( echo $cmd3 $cmd4 $cmd5 $cmd6 $cmd7 $cmd8 $cmd9 $cmd10 $cmd11 $cmd12 | sed "s/'//g" )
                   file="$( realpath $file )"
                fi
           elif [[ $cmd1 == 'run' ]] ; then
               python3 shareqr.py $file                    
           elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
               cd .. ; break
           elif [[ $cmd1 == '!' ]]; then
              $cmd3 $cmd4 $cmd5 $cmd6 $cmd7 $cmd8 $cmd9 $cmd10 $cmd11 $cmd12              
           fi
    else
        break       
    fi        
done               	
