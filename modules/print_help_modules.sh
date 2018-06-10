
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

print_modules(){
   echo -e "$red   ┬               ${yellow}Mod${red}ules"
   echo -e "$red   ├ "
   echo -e "$red   ├ $green net/iface             ${red}➤       ${white}Interface info."
   echo -e "$red   ├ $green net/map               ${red}➤       ${white}Hosts live Scan in LAN."
   echo -e "$red   ├ $green net/scan              ${red}➤       ${white}Scan [Ports, OS, Etc] IP."
   echo -e "$red   ├ $green net/vuln              ${red}➤       ${white}Scan for common vulnerabilities."
   echo -e "$red   ├ $green net/sniff             ${red}➤       ${white}Unencrypted traffic network sniffer and modifier."
   echo -e "$red   ├ $green net/sslsniff          ${red}➤       ${white}Sslstrip and sniff traffic."
   echo -e "$red   ├ $green net/cut               ${red}➤       ${white}Cut connection bettwen two points or more."
   echo -e "$red   ├"
   echo -e "$red   ├ $green info/site             ${red}➤       ${white}Website information"
   echo -e "$red   ├ $green info/phone            ${red}➤       ${white}Phone number onformation"
   echo -e "$red   ├ $green info/server           ${red}➤       ${white}Find IP Address And E-mail Server"
   echo -e "$red   ├ $green info/whois            ${red}➤       ${white}Domain whois lookup"
   echo -e "$red   ├ $green info/loc              ${red}➤       ${white}Find website/IP address location"
   echo -e "$red   ├ $green info/bcf              ${red}➤       ${white}Bypass cloudFlare"
   echo -e "$red   ├ $green info/subdomain        ${red}➤       ${white}Subdomain scanner"
   echo -e "$red   ├ $green info/valid            ${red}➤       ${white}Check Email address validation"     
   echo -e "$red   ├ $green info/domain           ${red}➤       ${white}Search Domain for Email addresses"        
   echo -e "$red   ├ $green info/email            ${red}➤       ${white}Email information gathering"     
   echo -e "$red   ├"
   echo -e "$red   ├ $green web/dirscan           ${red}➤       ${white}Scan for hidden web directories"    
   echo -e "$red   ├"
   echo -e "$red   ├ $green com/chat              ${red}➤       ${white}create or join an existing chatroom"
   echo -e "$red   ├ $green com/qrshare           ${red}➤       ${white}Send files using qr codes"      
   echo -e "$red   ├"   
   echo -e "$red   ├ $green torrent/search        ${red}➤       ${white}Search for torrents ans get thier info"
   echo -e "$red   ├ $green torrent/get           ${red}➤       ${white}Download torrents using command line"
   echo -e "$red   ├"   
   echo -e "$red   ├ $green crypto/rot            ${red}➤       ${white}Rot1..25 decoder"
   echo -e "$red   ├ $green crypto/auto           ${red}➤       ${white}Detect and decode encoded strings & crack hashes"
   echo -e "$red   ├ $green crypto/mdr1           ${red}➤       ${white}Encode/decode strings using our own Encoding algorithm"   
   echo -e "$red   ├ $green crypto/find           ${red}➤       ${white}Find hashes inside files [md5,sha256,sha512crypt,etc..]"      
   echo -e "$red   ├"  
   echo -e "$red   ├ $green phish/fb              ${red}➤       ${white}Facebook phishing using ngrok."    
   echo -e "$red   ├ $green phish/google          ${red}➤       ${white}Google phishing using ngrok." 
   echo -e "$red   ├ $green phish/in              ${red}➤       ${white}LinkedIn phishing using ngrok."    
   echo -e "$red   ├ $green phish/git             ${red}➤       ${white}Github phishing using ngrok."   
   echo -e "$red   ├ $green phish/stack           ${red}➤       ${white}StackOverflow phishing using ngrok."    
   echo -e "$red   ├ $green phish/wp              ${red}➤       ${white}WordPress phishing using ngrok."
   echo -e "$red   ├ $green phish/twitter         ${red}➤       ${white}Twitter phishing using ngrok."
   echo -e "$red   └"
   echo ""
}
print_help(){
   echo -e "$red   ┬                  ${yellow}H${red}elp"
   echo -e "$red   ├ "
   echo -e "$red   ├ $green show modules     ${red}➤     ${white}List all available modules"
   echo -e "$red   ├ $green use + <module>   ${red}➤     ${white}Use module"
   echo -e "$red   ├ $green show options     ${red}➤     ${white}Show module options"
   echo -e "$red   ├ $green banner           ${red}➤     ${white}Display an awesome rebel banner"
   echo -e "$red   ├ $green set              ${red}➤     ${white}Set a value to an option"
   echo -e "$red   ├ $green run              ${red}➤     ${white}Run module"
   echo -e "$red   ├ $green clear/reset      ${red}➤     ${white}Clear screen"
   echo -e "$red   ├ $green back             ${red}➤     ${white}Back to the main"
   echo -e "$red   ├ $green exit - quit      ${red}➤     ${white}Exit from rebel"
   echo -e "$red   ├ $green ! <cmd>          ${red}➤     ${white}Execute shell commands"
   echo -e "$red   ├ $green help - ?         ${red}➤     ${white}Show this message"
   echo -e "$red   └"
   echo ""

}

if [[ $1 == "help" ]] ; then
    print_help
elif [[ $1 == "modules" ]] ; then
    print_modules
fi
