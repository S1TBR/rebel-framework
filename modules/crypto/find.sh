#!/bin/bash
trap "exit" SIGINT SIGTERM

red='\e[1;31m'
green='\e[1;32m'
white='\e[97m'
shadow(){
    echo -e "${red}[+] sha512crypt Hashes "
    if ! [[ $(strings -n 98 $1 | grep '$6$...............................................................................................') == "" ]] ; then
       echo -en $green
       for i in $(strings $1 | grep -e '$6$...............................................................................................' -o -w | sort -u) ; do
          echo "   [+] $i"
       done
    else
        echo "[!] Could not find sha512crypt \$6\$ hashes"
    fi
}
md5(){
    echo -e "${red}[+] MD5|(NT|LM)|MD4|MD2 Hashes"
    if ! [[ $(strings $1 | grep -o -w -e "[0-9a-f]\{32\}" ) == "" ]] ; then
       echo -en $green
       for i in $(strings $1 | grep -o -w -e "[0-9a-f]\{32\}"  | sort -u) ; do
         echo "   [+] $i"
       done
    else
        echo "[!] Could not find any MD5 hashes"
    fi

}
winzip(){
    echo -e "${red}[+] WinZip Hashes"
    if ! [[ $(strings $1 | grep '$zip2$............................................................................' ) == "" ]] ; then
        echo -en $green
        for i in $(strings $1 | grep  -e '$zip2$............................................................................' -o -w  | sort -u); do
           echo "   [+] $i"
        done
    else
        echo "[!] Could not find any MD5 hashes"
    fi
}
sha1(){
    echo -e "${red}[+] SHA-1 Hashes"
    if ! [[ $(strings $1 | grep -o -w -e "[0-9a-f]\{40\}" ) == "" ]] ; then
       echo -en $green
       for i in $(strings $1 | grep -o -w -e "[0-9a-f]\{40\}"  | sort -u) ; do
          echo "   [+] $i"
       done
    else
        echo "[!] Could not  find any SHA-1 hashes"
    fi

}
sha224(){
    echo -e "${red}[+] Joomla < 2.5.18|NTLM Hashes "
    if ! [[ $(strings $1 | grep -o -w -e "[0-9a-f]\{56\}") == "" ]] ; then
       echo -en $green
       for i in $(strings $1 | grep -o -w -e "[0-9a-f]\{56\}"  | sort -u); do
          echo "   [+] $i"
       done
    else
        echo "[!] Could not find any SHA-224 hashes"
    fi

}
joomla(){
  echo -e "${red}[+] Joomla < 2.5.18|NTLM Hashes"
  if ! [[ $(strings $1 | grep -o -w -e "[0-9a-f]\{32\}:[0-9a-f]\{32\}") == "" ]] ; then
     echo -en $green
     for i in $(strings $1 | grep -o -w -e "[0-9a-f]\{32\}:[0-9a-f]\{32\}"  | sort -u); do
        echo "   [+] $i"
     done
  else
      echo "[!] Could not find any Joomla < 2.5.18|NTLM hashes"
  fi

}
7z(){
  echo -e "${red}[+] 7-ZIP Hashes"
  if ! [[ $(strings $1 | grep -o -w -e '$7z$................................................................................................................................................................................................................................................................................................' | sort -u) == "" ]] ; then
     echo -en $green
     for i in $(strings $1 | grep -o -w -e '$7z$................................................................................................................................................................................................................................................................................................' | sort -u) ; do
       echo "   [+] $i"
     done
  else
      echo "[!] Could not find any 7-zip hashes"
  fi

}
rar5(){
  echo -e "${red}[+] RAR-5 Hashes"
  if ! [[ $(strings $1 | grep -o -w -e '$rar5$..........................................................................................') == "" ]] ; then
     echo -en $green
     for i in $(strings $1 |  grep -o -w -e '$rar5$..........................................................................................' | sort -u) ; do
        echo "   [+] $i"
     done
  else
      echo "[!] Could not find any rar-5 hashes"
  fi

}
help(){
    echo -en $green
    echo '[-]== H - G R E P ==[-]'
    echo '[-]== Usage ./Hgrep.sh <filename> <hashtype(s)\all>'
    echo '[-]== Options : '
    echo '[-]==== -r, --recursive   -> run the script recursively'
    echo '[-]==== -a  --all         -> search for all supported hash types'
    echo '[-]==== Hashes list :'
    echo "[-]====== md2        "
    echo "[-]====== md4        "
    echo "[-]====== md5        "
    echo "[-]====== LM         "
    echo "[-]====== NT         "
    echo "[-]====== NTLM       "
    echo "[-]====== sha1       "
    echo "[-]====== sha224     "
    echo "[-]====== sha256     "
    echo "[-]====== 7z         "
    echo "[-]====== winzip     "
    echo "[-]====== rar5       "
    echo "[-]====== sha512     "
    echo "[-]====== shadow(sha512crypt)"
    echo "[-]====== jom(Joomla < 2.5.18)"
    echo '[-]== Examples :'
    echo "[-]===== ./Hgrep.sh flag.pcap --all             "
    echo "[-]===== ./Hgrep.sh extractme.bin md5,md4,jom,shadow"
    echo "[-]===== ./Hgrep.sh ~/Downloads/findme/ -r -a   "
    exit 1
}
main(){
       file="$1"
       options="$2"
       echo -e "$green[+] Filename : $file"
       if [[ $options =~ '--all' ]] || [[ $options =~ '-a' ]] ; then
          shadow $file ; echo ""
          md5    $file ; echo ""
          sha1   $file ; echo ""
          sha224 $file ; echo ""
          winzip $file ; echo ""
          joomla $file ; echo ""
          7z     $file ; echo ""
          rar5   $file ; echo ""
       else
         if [[ $options =~ "shadow" ]] ; then
             shadow $file ; echo ""
         fi
         if [[ $options =~ "md" ]] || [[ $options =~ "lm" ]] || [[ $options =~ "nt" ]] ; then
             md5 $file ; echo ""
         fi
         if [[ $options =~ "rar5" ]] ; then
             rar5 $file ; echo ""
         fi
         if [[ $options =~ "jom" ]] ; then
             joomla $file ; echo ""
         fi
         if [[ $options =~ "sha1" ]] ; then
             sha1 $file ; echo ""
         fi
         if [[ $options =~ "7z" ]] ; then
             7z $file ; echo ""
         fi
         if [[ $options =~ "sha224" ]] ; then
             sha224 $file ; echo ""
         fi
         if [[ $options =~ "winzip" ]] ; then
             winzip $file ; echo ""
         fi
      fi
}
path=$(echo $1 | sed "s/'//g" )
if [[ $(echo $1 $2) =~ '-r' ]] || [[ $(echo $1 $2) =~ '--recursive' ]] ; then
      p=$3   
   for i in $(find $path ) ; do
      if [[ -f $i ]] ; then 
         main $(realpath $i) $p
      fi   
   done
else
   if [[ -f $1 ]] ; then
      f=$1
      p=$2
   elif [[ -f $2 ]] ; then
      f=$2
      p=$1
   fi
   main $f $p
fi
