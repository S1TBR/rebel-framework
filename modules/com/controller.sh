#!/bin/bash
normal='\e[0m'
arr[0]='\e[1;94m' ; blue=${arr[0]}
arr[1]='\e[1;31m' ; red=${arr[1]}
arr[2]='\e[1;33m' ; yellow=${arr[2]}
arr[3]='\e[1;35m' ; purp=${arr[3]}
arr[4]='\e[1;32m' ; green=${arr[4]}
arr[5]='\e[97m'   ; white=${arr[5]}
grayterm='\e[1;40m'

nickname="rebellion"
room="rebel"
mode="send"
sender="autofind"
file="example.tar.gz"
module=$(echo $1 | cut -d '/' -f 2 )
if [[ $module != "chat" ]] && [[ $module != "qrshare" ]] ; then
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
    if [[ ${1} == 'com/chat' ]] ; then 
	       if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              echo '  Option                                   Value'
	            echo '  ======                                   ====='
	            echo "  room                                     $room"
	            echo "  nickname                                 $nickname"
	            echo	          
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi              
         elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
	         if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'room' ]] ; then
                room="$( echo $cmd1 | cut -d " " -f 3- )"
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "nickname" ]] ; then
                nickname="$( echo $cmd1 | cut -d " " -f 3- )"
           fi	
         elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
            termchat -r $room -n $nickname 
         else
            misc $cmd1      
         fi
    elif [[ ${1} == "com/qrshare" ]] ; then
         if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              echo '  Option                                   Value'
	            echo '  ======                                   ====='
	            echo "  file                                     $file"
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi                
         elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
	          if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'file' ]] ; then
               file=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g" )
               file="$( realpath $file )"
            fi
         elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
              python3 shareqr.py $file                    
         else
              misc $cmd1
         fi   
    fi        
done               	
