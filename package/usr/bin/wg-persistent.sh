#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "enter host wg-interface in args"
  return
fi

CHECK_FILE=/tmp/wg-persist-$2

if ping -c 1 -W 3 $1 > /dev/null
then
  echo 0 > CHECK_FILE
  exit 0
fi
  
echo no connection, mark it
failcount=0
let "failcount += $(cat CHECK_FILE)"
let "failcount=failcount+1"

echo $failcount > CHECK_FILE
cat CHECK_FILE

if [ $failcount > 10 ] ; then
  systemctl stop wg-quick@$2
  sleep 2
  systemctl start wg-quick@$2
fi

rm CHECK_FILE
