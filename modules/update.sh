#!/bin/bash
current_path=$( cd .. ; pwd )
cd /tmp
wget https://raw.githubusercontent.com/rebellionil/rebel-framework/master/modules/.is_up_to_date 2> /dev/null

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
       rm -rf ${current_path}/modules ;  mv modules ${current_path}
       cd ..
       rm -rf rebel-framework
       cd ${current_path} ; bash setup.sh
       echo "[+] The Framework is uptodate ."
       kill `ps aux | grep rebel.sh | grep -v color  | awk {' print $2 '}` 2> /dev/null 1> /dev/null
    fi
fi

