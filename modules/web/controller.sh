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

if [[ $module != "dirscan" ]] && [[ $module != "appscan" ]] && [[ $module != "cmsscan" ]] ; then
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
        bash ../../print_help_modules.sh help 
    elif [[ $1 == "banner" ]] ; then
        rand="$[ $RANDOM % 6 ]"
        color="${arr[$rand]}" # select random color
        echo -e $color
        python ../../print_banner.py  
    elif [[ $1 == "" ]] ; then
        :               
    else
       echo -e "${purp}[-] Invalid parameter use show 'help' for more information"         
    fi    
}

target="google.com"
extension="php,html,js,txt,htm"
wordlist="db/dicc.txt"
delay="default"
recursive="off"
subdir="off"
exsubdir="off"
if [[ $module == "cmsscan" ]] ; then
   threads="5"
else
   threads="100"
fi      
exstatus="400,403,500,301"
cookie="off"
useragent="off"
randomagent="off"
timeout="default"
proxy="off"
ip="off"
rbh="off"
limit="3"

force="nul"
fullscan="off"
noexploit="off"

while IFS= read -e -p "$( echo -e $white ; echo -e ${grayterm}{REBEL}➤[${white}$1]~#${normal} ) " cmd1 ; do
    history -s "$( echo $cmd1 | cut -d " " -f 1 )"
    if [[ ${1} =~ 'web/dirscan' ]] ; then
      if [[ $( pwd | tr '/' '\n' | tail -n 1 ) != "dirsearch_mod" ]] ; then
           	   cd dirsearch_mod
      fi
      if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
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
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
          bash ../../print_help_modules.sh modules
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
          bash ../../print_help_modules.sh help
        fi 

      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
	      if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
          target=$( echo $cmd1 | cut -d " " -f 3- )

	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'extension' ]] ; then
          extension=$( echo $cmd1 | cut -d " " -f 3- )

	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'wordlist' ]] ; then
          wordlist=$( echo $cmd1 | cut -d " " -f 3- )

	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'delay' ]] ; then
          delay=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $delay != "default" ]] ; then
             delay_arg="-s $( echo $cmd1 | cut -d " " -f 3- )"
          else
             delay_arg=""    
          fi   

	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'recursive' ]] ; then
          recursive=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $recursive == "on" ]] ; then
             recursive_arg="-r"
          else
             recursive=""   
          fi                     
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'subdir' ]] ; then
          subdir=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $subdir != "off" ]] ; then
              subdir_arg="--scan-subdir=$( echo $cmd1 | cut -d " " -f 3- )"
          else
              subdir_arg=""    
          fi                    
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'exsubdir' ]] ; then
          exsubdir=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $exsubdir != "off" ]] ; then
              exsubdir_arg="--exclude-subdir=$( echo $cmd1 | cut -d " " -f 3- )"
          else
              exsubdir_arg=""    
          fi                      
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'exstatus' ]] ; then
          exstatus=$( echo $cmd1 | cut -d " " -f 3- )

	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'cookie' ]] ; then
          cookie=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $cookie != "off" ]] ; then
              cookie_arg="--cookie=$( echo $cmd1 | cut -d " " -f 3- )"
          else
              cookie_arg=""   
          fi                    
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'useragent' ]] ; then
          useragent=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $useragent != "off" ]] ; then
              useragent_arg="--ua=$( echo $cmd1 | cut -d " " -f 3- )"
          else
              useragent_arg=""    
          fi                   
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'randomagent' ]] ; then
          randomagent=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $randomagent == "on" ]] ; then
              randomagent_arg="--random-agents"
          else
              randomagent_arg=""   
          fi	   
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'timeout' ]] ; then
          timeout=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $timeout != "default" ]] ; then
              timeout_arg="--timeout=$( echo $cmd1 | cut -d " " -f 3- )"
          else
              timeout_arg=""  
          fi	  
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'ip' ]] ; then
          ip=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $ip != "off" ]] ; then
              ip_arg="--ip=$( echo $cmd1 | cut -d " " -f 3- )"
          else
              ip_arg=""    
          fi                      
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'proxy' ]] ; then
          proxy=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $proxy != "off" ]] ; then
              proxy_arg="--proxy=$( echo $cmd1 | cut -d " " -f 3- )"
          else
              proxy_arg=""   
          fi   
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'rbh' ]] ; then
          rbh=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $rbh == "on" ]] ; then
              rbh_arg="-b"
          else
              rbh_arg=""  
          fi                     
	      elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'threads' ]] ; then
          threads=$( echo $cmd1 | cut -d " " -f 3- )                                                                                                                                                                                                                                                
        fi
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
        if [[ -f $target ]] ; then
           iswordlist='-L'
        else
           iswordlist='-u'  
        fi    	
           python3 main.py $iswordlist $target -e $extension -t $threads -x $exstatus -w $wordlist $delay_arg $recursive_arg $subdir_arg $exsubdir_arg $cookie_arg $useragent_arg $randomagent_arg $timeout_arg $ip_arg $proxy_arg $rbh_arg            
      else        
         misc $cmd1
      fi 
   elif [[ ${1} =~ 'web/appscan' ]] ; then
      if [[ $( pwd | tr '/' '\n' | tail -n 1 ) != "blackwidow_mod" ]] ; then
               cd blackwidow_mod
      fi
      if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
         {
          echo -e "  Option\t\t\t\t|Value"
          echo -e "  ======\t\t\t\t|====="
          echo -e "  target\t\t\t\t|$target|[domain.com,single_url.com/full/path/to/param.php?page=1]" 
          echo -e "  cookie\t\t\t\t|$cookie"
          echo -e "  limit\t\t\t\t|$limit|[crawling depth limit]"
         } | column -t -s "|"

        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
          bash ../../print_help_modules.sh modules
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
          bash ../../print_help_modules.sh help
        fi 
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
          target=$( echo $cmd1 | cut -d " " -f 3- )

        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'cookie' ]] ; then
          cookie=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $cookie != "off" ]] ; then
              cookie_arg="-c $( echo $cmd1 | cut -d " " -f 3- )"
          else
              cookie_arg=""   
          fi     
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "limit" ]] ; then 
           limit=$( echo $cmd1 | cut -d " " -f 3- )   
        fi
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
         if [[ $target =~ '=' ]] && [[ $target =~ "?" ]] ; then
            python injectx.py $target
         else 
            python blackwidow -d $target -l $limit $cookie 2> /dev/null  
         fi
      else
            misc $cmd1
      fi  
  elif [[ ${1} =~ 'web/cmsscan' ]] ; then
      if [[ $( pwd | tr '/' '\n' | tail -n 1 ) != "cmsmap_mod" ]] ; then
               cd cmsmap_mod
      fi
      if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
       if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
        {
          echo -e "  Option\t\t\t\t|Value"
          echo -e "  ======\t\t\t\t|====="
          echo -e "  target\t\t\t\t|$target|[etc.com/sites.txt]"
          echo -e "  threads\t\t\t\t|$threads|[Number of Threads]"
          echo -e "  useragent\t\t\t\t|$useragent"
          echo -e "  force\t\t\t\t|$force|[force scan (W)ordpress, (J)oomla or (D)rupal]"
          echo -e "  fullscan\t\t\t\t|$fullscan|[full scan using large plugin lists(SLOW)]"
          echo -e "  noexploit\t\t\t\t|$noexploit|[enumerate plugins without searching exploits]"
          echo
         } | column -t -s "|"
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
          bash ../../print_help_modules.sh modules
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
          bash ../../print_help_modules.sh help
        fi 

      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'target' ]] ; then
          target=$( echo $cmd1 | cut -d " " -f 3- )
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'threads' ]] ; then
          threads=$( echo $cmd1 | cut -d " " -f 3- )
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'useragent' ]] ; then
          useragent=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $useragent != "off" ]] ; then
              useragent_arg="--ua=$( echo $cmd1 | cut -d " " -f 3- )"
          else
              useragent_arg=""    
          fi     
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'force' ]] ; then
          force=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $force != "nul" ]] ; then
              force_arg="-f $( echo $cmd1 | cut -d " " -f 3- )"
          else
              force_arg=""    
          fi 
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'fullscan' ]] ; then
          fullscan=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $fullscan != "off" ]] ; then
              fullscan_arg="-F"
          else
              fullscan_arg=""    
          fi           
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'noexploit' ]] ; then
          noexploit=$( echo $cmd1 | cut -d " " -f 3- )
          if [[ $noexploit != "off" ]] ; then
              noexploit_arg="--noedb"
          else
              noexploit_arg=""    
          fi           
        fi  
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == "run" ]]  ; then
         python cmsmap.py -t $target -T $threads $fullscan_arg $noexploit_arg $useragent_arg $force_arg
      else
         misc $cmd1
      fi                                                
  fi
done
