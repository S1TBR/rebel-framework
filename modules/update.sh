#!/bin/bash
trap  "echo '[x] Please wait till the update finish, exiting now can corrupt the framework files'" SIGINT SIGTERM
current_path=$( cd .. ; pwd )
cd /tmp
wget https://raw.githubusercontent.com/rebellionil/rebel-framework/master/modules/.is_up_to_date --output-document=.is_up_to_date 2> /dev/null
if [[ $(cat .is_up_to_date ) =~ '+' ]] ; then
   resetup="true"
fi
if ! [[ $( diff ${current_path}/modules/.is_up_to_date .is_up_to_date ) == "" ]] ; then
    echo -e "[*] Checking for updates.. "
    echo -n "[+] New Updates are avilable, Update the Framework ? [Y/n] "
    read update
    if [[ $update =~ "y" ]] || [[ $update == "" ]] || [[ $update =~ "Y" ]] ; then
       echo -en "[+] Cloning Rebel-framework... \r"
       git clone https://github.com/rebellionil/rebel-framework 2> /dev/null
       rm -rf .is_up_to_date
       cd rebel-framework
       echo -e "[+] Cloning Rebel-framework... done"
       mv rebel.sh ${current_path}
       mv setup.sh ${current_path}
       mv ${current_path}/modules/phish/Server/ngrok ${currnet_path}
       rm -rf ${current_path}/modules
       mv modules ${current_path}
       mv ${current_path}/ngrok ${current_path}/modules/phish/Server/ngrok 
       cd ..
       rm -rf rebel-framework
       if [[ $resetup == "true" ]] ; then
          cd ${current_path} ; xterm -T "SETUP" -e "bash setup.sh"
       fi
       echo "[+] The Framework is uptodate ."
       kill `ps aux | grep rebel.sh | grep -v color  | awk {' print $2 '}` 2> /dev/null 1> /dev/null
    fi
fi


