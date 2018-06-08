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

rot="all"
mode="encode"
if [[ $1 == "crypto/rot" ]] ; then
   target="ifmmp gsjfoe"
else
   target="68656c6c6f20667269656e64"
fi
while true ; do
  echo -e "$white"
  if [[ ${1} =~ 'crypto/rot' ]] ; then
    echo -en "${grayterm}{REBEL}➤[${white}crypto/rot]~#${normal} "
    read cmd1
	  if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] && [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
        echo '  Option                                   Value'
	      echo '  ======                                   ====='
	      echo "  target                                   $target"
	      echo "  rot                                      $rot\t[all/(1..25)]"
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
        $( echo $cmd1 | cut -d " " -f 2- )
    fi     
  elif [[ ${1} =~ 'crypto/auto' ]] ; then
    echo -en "${grayterm}{REBEL}➤[${white}crypto/auto]~#${normal} "
    read cmd1
    if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] && [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
       echo '  Option                                   Value'
	     echo '  ======                                   ====='
	     echo "  target                                   $target"
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
    fi     
  elif [[ ${1} =~ 'crypto/mdr1' ]] ; then
    echo -en "${grayterm}{REBEL}➤[${white}crypto/mdr1]~#${normal} "
    read cmd1
    if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] && [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
        echo '  Option                                   Value'
	      echo '  ======                                   ====='
	      echo -e "  target                                   $target"
	      echo -e "  mode                                     $mode\t(encode/decode)"
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
    fi     
  else
    break
  fi
done
