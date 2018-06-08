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

target="google.com"
extension="php,html,js,txt,htm"
wordlist="db/dicc.txt"
delay="default"
recursive="off"
subdir="off"
exsubdir="off"
threads="100"
exstatus="400,403,500,301"
cookie="off"
useragent="off"
randomagent="off"
timeout="default"
ip="off"
proxy="off"
rbh="off"
while true ; do
    echo -e "$white"	
    if [[ ${1} =~ 'web/dirscan' ]] ; then
           if [[ $( pwd | tr '/' '\n' | tail -n 1 ) != "dirsearch_mod" ]] ; then
           	   cd dirsearch_mod
           fi	   
           echo -en "${grayterm}{REBEL}➤[${white}web/dirscan]~#${normal} " ; read cmd1 cmd2 cmd3 cmd4 cmd5 cmd6 cmd7 cmd8
	       if [[ $cmd1 == "show" ]] && [[ $cmd2 == "options" ]] ; then
	       	  {
                 echo -e "  Option\t\t\t\t|Value"
	             echo -e "  ======\t\t\t\t|====="
	             echo -e "  target\t\t\t\t|$target|[etc.com/sites.txt]"
	             echo -e "  extension\t\t\t\t|$extension"                   
                 echo -e "  wordlist\t\t\t|$wordlist"                    
                 echo -e "  delay\t\t\t\t|$delay|[float number]"
                 echo -e "  recursive\t\t\t\t|$recursive|(on/off) [Bruteforce recursively]"
                 echo -e "  subdir\t\t\t|$subdir|[Scan subdirectories of url (separated by comma)]"
                 echo -e "  exsubdir\t\t\t\t|$exsubdir|[Exclude the following subdirectories during recursivescan (separated by comma)]"
                 echo -e "  threads\t\t\t\t|$threads|[Number of Threads]"
                 echo -e "  exstatus\t\t\t\t|$exstatus|[Exclude status code, separated by comma (example: 301,500)]" #*
                 echo -e "  cookie\t\t\t\t|$cookie"
                 echo -e "  useragent\t\t\t\t|$useragent"
                 echo -e "  randomagent\t\t\t\t|$randomagent|(on/off)"
                 echo -e "  timeout\t\t\t\t|$timeout|[Connection timeout]"
                 echo -e "  ip\t\t\t\t|$ip|[Resolve name to IP address]"
                 echo -e "  proxy\t\t\t\t|$proxy|[http Proxy (example: localhost:8080)]"
                 echo -e "  rbh\t\t\t\t|$rbh|(on/off) [By default it request by IP for speed.This forces requests by hostname]"
	             echo
	          } | column -t -s "|"

           elif [[ $cmd1 == 'set' ]] ; then
	            if [[ $cmd2 == 'target' ]] ; then
                   target=$cmd3
	            elif [[ $cmd2 == 'extension' ]] ; then
                   extension=$cmd3
	            elif [[ $cmd2 == 'wordlist' ]] ; then
                   wordlist=$cmd3
	            elif [[ $cmd2 == 'delay' ]] ; then
                   delay=$cmd3
                   if [[ $delay != "default" ]] ; then
                       delay_arg="-s $cmd3"
                   else
                       delay_arg=""    
                   fi   
	            elif [[ $cmd2 == 'recursive' ]] ; then
                   recursive=$cmd3
                   if [[ $recursive == "on" ]] ; then
                       recursive_arg="-r"
                   else
                       recursive=""   
                   fi                     
	            elif [[ $cmd2 == 'subdir' ]] ; then
                   subdir=$cmd3
                   if [[ $subdir != "off" ]] ; then
                       subdir_arg="--scan-subdir=$cmd3"
                   else
                       subdir_arg=""    
                   fi                    
	            elif [[ $cmd2 == 'exsubdir' ]] ; then
                   exsubdir=$cmd3
                   if [[ $exsubdir != "off" ]] ; then
                       exsubdir_arg="-c $cmd3"
                   else
                       exsubdir_arg=""    
                   fi                      
	            elif [[ $cmd2 == 'exstatus' ]] ; then
                   exstatus=$cmd3

	            elif [[ $cmd2 == 'cookie' ]] ; then
                   cookie=$cmd3
                   if [[ $cookie != "off" ]] ; then
                       cookie_arg="=$cmd3"
                   else
                       cookie_arg=""   
                   fi                    
	            elif [[ $cmd2 == 'useragent' ]] ; then
                   useragent=$cmd3
                   if [[ $useragent != "off" ]] ; then
                       useragent_arg="--ua=$cmd3"
                   else
                       useragent_arg=""    
                   fi                   
	            elif [[ $cmd2 == 'randomagent' ]] ; then
                   randomagent=$cmd3
                   if [[ $randomagent == "on" ]] ; then
                   	   randomagent_arg="--random-agents"
                   else
                       randomagent_arg=""   
                   fi	   
	            elif [[ $cmd2 == 'timeout' ]] ; then
                   timeout=$cmd3
                   if [[ $timeout != "default" ]] ; then
                   	  timeout_arg="--timeout=$cmd3"
                   else
                      timeout_arg=""  
                   fi	  
	            elif [[ $cmd2 == 'ip' ]] ; then
                   ip=$cmd3
                   if [[ $ip != "off" ]] ; then
                       ip_arg="--ip=$cmd3"
                   else
                       ip_arg=""    
                   fi                      
	            elif [[ $cmd2 == 'proxy' ]] ; then
                   proxy=$cmd3
                   if [[ $proxy != "off" ]] ; then
                       proxy_arg="--proxy=$cmd3"
                   else
                       proxy_arg=""   
                   fi   
	            elif [[ $cmd2 == 'rbh' ]] ; then
                   rbh=$cmd3
                    if [[ $rbh == "on" ]] ; then
                       rbh_arg="-b"
                    else
                       rbh_arg=""  
                    fi                     
	            elif [[ $cmd2 == 'threads' ]] ; then
                   threads=$cmd3                                                                                                                                                                                                                                                
                fi
           elif [[ $cmd1 == 'run' ]] ; then
           	   if [[ -f $target ]] ; then
           	      iswordlist='-L'
           	   else
           	      iswordlist='-u'  
           	   fi    	
               python3 main.py $iswordlist $target -e $extension -t $threads -x $exstatus -w $wordlist $delay_arg $recursive_arg $subdir_arg $exsubdir_arg $cookie_arg $useragent_arg $randomagent_arg $timeout_arg $ip_arg $proxy_arg $rbh_arg 
           elif [[ $cmd1 == "back" ]] || [[ $cmd1 == "exit" ]] || [[ $cmd1 == "quit" ]] ; then
               cd .. ; break
           elif [[ $cmd1 == '!' ]];then
              $cmd2             
           fi  
    else
       break
    fi       
done