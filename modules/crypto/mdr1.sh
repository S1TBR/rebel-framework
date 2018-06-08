#!/bin/bash
c=("019?" "028?" "071?" "087?" "100?" "126?" "145?" "149?" "151?" "155?" "162?" "163?" "170?"
   "186?" "187?" "196?" "199?" "207?" "219?" "223?" "226?" "228?" "232?" "277?" "279?" "305?"
   "311?" "316?" "326?" "334?" "346?" "361?" "369?" "371?" "372?" "382?" "386?" "422?" "461?"
   "482?" "511?" "514?" "518?" "541?" "558?" "581?" "582?" "610?" "612?" "622?" "625?" "631?" "763?")
str="A B C D E F G H I J K L M N O P Q R S T U V ' W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z"
#num=("B" "p" "G" "w" "F" "i" "H" "v" "m" "Y")
num=('S@f' 'EPT' 'xRi' 'ZvZ' 'DLM' 'YOR' 'AeF' 'OhC' 'LwN' 'LGQ')
n=("a" "T" "c" "L" "e" "O" "J" "U" "X" "Q")
normal='\e[0m'
blue='\e[1;94m'
red='\e[1;31m'
yellow='\e[1;33m'
ul='\e[1;4m'
purp='\e[1;35m'
green='\e[1;32m'
white='\e[97m'
enc(){
  var="$1"
  xx=0
  for i in {0..9}; do
     bb=$( echo $var | sed "s/$i/${num[$i]}/g")
     var=$bb
  done
  for i in $str; do
    char=$( echo $var | sed "s/$i/${c[$xx]}/g" )
    var=$char
    let xx+=1
  done
  for i in {0..9}; do
     binx=$( echo $var | sed "s/$i/${n[$i]}/g" )
     var=$binx
  done
  var=$( echo $var | sed 's/ /!/g' | sed 's/\n/;:/g')
}
dec(){
  var="$1"
  var=$( echo $var | sed 's/!/ /g' | sed 's/;:/\n/g')
  for i in {0..9}; do
     binx=$( echo $var | sed "s/${n[$i]}/$i/g" )
     var=$binx
  done
  xx=0
  for i in $str; do
    char=$( echo $var | sed "s/${c[$xx]}/$i/g" | sed 's/210/a/g')
    var=$char
    let xx+=1
  done
  for i in {0..9}; do
     bb=$( echo $var | sed "s/${num[$i]}/$i/g" )
     var=$bb
  done
  var=$(echo $var | sed "s/++$//g" )

}
if ! [[ $2 == "" ]] ; then
  if [[ $1 == "-e" ]] ; then
    enc "${2}++"
    echo -e "${yellow} [+] Plain text : $2 "
    echo -e "${green} [+] Encrypted value : $var "
    if [[ $( echo "$2" ) =~ "-f" ]] ; then
             echo "$var" >> "$3"
             echo "saved to $3 file"
    fi
  elif [[ $1 == "-d" ]] ; then
         dec "${2}"
         echo -e "${yellow} [+] Encrypted value : $2 "
         echo -e "${green} [+] Plain text : $var "
  else
    echo "Usage. $0 < -d / -e > <input>"
  fi
else
  echo "Usage. $0 < -d / -e > <input>"
fi

