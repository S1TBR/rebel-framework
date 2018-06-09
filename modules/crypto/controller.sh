#!/bin/bash
normal='\e[0m'
arr[0]='\e[1;94m' ; blue=${arr[0]}
arr[1]='\e[1;31m' ; red=${arr[1]}
arr[2]='\e[1;33m' ; yellow=${arr[2]}
arr[3]='\e[1;35m' ; purp=${arr[3]}
arr[4]='\e[1;32m' ; green=${arr[4]}
arr[5]='\e[97m'   ; white=${arr[5]}
grayterm='\e[1;40m'


rot="all"
mode="encode"

hash="-a"
files="off"

module=$(echo $1 | cut -d '/' -f 2 )
if [[ $module != "rot" ]] && [[ $module != "mdr1" ]] && [[ $module != "auto" ]] && [[ $module != "find" ]] ; then
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

if [[ $1 == "crypto/rot" ]] ; then
   target="ifmmp gsjfoe"
elif [[ $1 == "crypto/find" ]] ; then
   target="example.txt"
   mode="all"
else   
   target="68656c6c6f20667269656e64"
fi


while IFS= read -e -p "$( echo -e $white ; echo -e ${grayterm}{REBEL}➤[${white}$1]~#${normal} ) " cmd1 ; do
    history -s "$cmd1"
    if [[ ${1} == 'crypto/rot' ]] ; then
    	  if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              {
              echo -e "  Option\t\t\t\t|Value"
              echo -e "  ======\t\t\t\t|====="
              echo -e "  target\t\t\t\t|$target"
              echo -e "  mode\t\t\t\t|$rot|[all/(1..25)]"
              } | column -t -s "|"                 
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi               
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
	         if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
               target=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "rot" ]] ; then
               rot=$( echo $cmd1 | cut -d " " -f 3- )
           fi
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "run" ]] ; then
           python3 main.py -rot $rot "$target"
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "back" ]] || [[ $( echo $cmd1 | cut -d " " -f 1 ) == "exit" ]] || [[ $( echo $cmd1 | cut -d " " -f 1 ) == "quit" ]] ; then
           cd .. ; break
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == '!' ]] ; then
           $( echo $cmd1 | cut -d " " -f 2 )
        else
           misc $cmd1           
        fi     
    elif [[ ${1} =~ 'crypto/auto' ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              {
              echo -e "  Option\t\t\t\t|Value"
              echo -e "  ======\t\t\t\t|====="
              echo -e "  target\t\t\t\t|$target"
              } | column -t -s "|"   
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi          
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
	         if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
              target=$( echo $cmd1 | cut -d " " -f 3- )
           fi    
        elif [[ $cmd1 == "run" ]] ; then
           python3 main.py "$target"
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "back" ]] || [[ $( echo $cmd1 | cut -d " " -f 1 ) == "exit" ]] || [[ $( echo $cmd1 | cut -d " " -f 1 ) == "quit" ]] ; then
           cd .. ; break
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == '!' ]] ; then
           $( echo $cmd1 | cut -d " " -f 2- )
        else
           misc $cmd1
        fi                  
    elif [[ ${1} == 'crypto/mdr1' ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              {
              echo -e "  Option\t\t\t\t|Value"
              echo -e "  ======\t\t\t\t|====="
              echo -e "  target\t\t\t\t|$target"
              echo -e "  mode\t\t\t\t|$mode|(encode/decode)"
              } | column -t -s "|"              
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi               
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
	         if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
               target=$( echo $cmd1 | cut -d " " -f 3- )
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "mode" ]] ; then
               mode=$( echo $cmd1 | cut -d " " -f 3- )
           fi
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "run" ]] ; then
           if [[ $mode == "encode" ]] ; then
               bash mdr1.sh -e "$target"
           elif [[ $mode == "decode" ]] ; then
               bash mdr1.sh -d "$target"
           else
               echo -e "${red}[x] Mode have to be Encode or Decode"
           fi
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "back" ]] || [[ $( echo $cmd1 | cut -d " " -f 1 ) == "exit" ]] || [[ $( echo $cmd1 | cut -d " " -f 1 ) == "quit" ]] ; then
           cd .. ; break
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == '!' ]] ; then
           $( echo $cmd1 | cut -d " " -f 2- )
        else
           misc $cmd1
        fi
    elif [[ ${1} == 'crypto/find' ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
              {
              echo -e "  Option\t\t\t\t|Value"
              echo -e "  ======\t\t\t\t|====="
              echo -e "  target\t\t\t\t|$target|[filename(for single files)/foldername(for recursive searching)]"
              echo -e "  mode\t\t\t\t|$mode|(all/md2/md4/md5/LM/NT/NTLM/sha1/sha224/sha256/7z/winzip/rar5/sha512/shadow/jom)"
              } | column -t -s "|"
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
              bash ../print_help_modules.sh modules
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
              bash ../print_help_modules.sh help
           fi               
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
           if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
               target=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g" )
               if [[ -d $target ]] ; then
                   files="-r"
               elif [[ -f $target ]] ; then
                   files=""
               else
                  echo -e "${red}[x] file/folder couldn't be found"       
               fi
           elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "mode" ]] ; then
               mode=$( echo $cmd1 | cut -d " " -f 3- )
               if [[ $mode == "all" ]] ; then
                  hash="-a"
               else  
                  hash="$mode" 
               fi    
           fi   
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "run" ]] ; then
           bash find.sh $target $files $hash   
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "back" ]] || [[ $( echo $cmd1 | cut -d " " -f 1 ) == "exit" ]] || [[ $( echo $cmd1 | cut -d " " -f 1 ) == "quit" ]] ; then
           cd .. ; break
        elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == '!' ]] ; then
           $( echo $cmd1 | cut -d " " -f 2- )
        else
           misc $cmd1
        fi                                            
    fi
done
