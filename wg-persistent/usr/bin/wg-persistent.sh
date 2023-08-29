#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "enter host wg-interface in args"
  exit 0
fi

CHECK_FILE=/tmp/wg-persist-$2
i=1
failcount=0
let "failcount += $(cat CHECK_FILE)"
while [ $i -le 7 ]
do
  let "i += 1"
  if ping -c 1 -W 3 $1 > /dev/null
  then
    echo 0 > CHECK_FILE
   
    exit 0
  fi

  echo no connection, mark it
  let "failcount=failcount+1"
  
  echo $failcount > CHECK_FILE
  
  if [ $failcount -ge 5 ] ; then
    systemctl stop wg-quick@$2
    sleep 2
    systemctl start wg-quick@$2
    rm CHECK_FILE
    exit 0
  fi
  sleep 4

done
