#!/bin/bash
####################################################
# Continuously check the app log for the occurance #
# of <PATTERN> and throw error if not found within #
# <THRESHOLD>                                      #
#                                                  #
####################################################
echo $$ > /tmp/session_monitor_legacy.pid
LOG_FILE=/tmp/server.log
THRESHOLD=120

NC ()
{
#NC function goes here
}
[ ! -f pattern.tmp ] && touch pattern.tmp

tail -Fn0 ${LOG_FILE} | \
while read line ; do
  echo "${line}" | awk '/Event:51/ { system("touch pattern.tmp") }'
  P_TIME=$(date +%s)
  F_TIME=$(stat pattern.tmp -c %Y)
  #echo "F_TIME is ${F_TIME}" >> some.file
  DIFF=$(expr ${P_TIME} - ${F_TIME})
  #echo "DIFF is ${DIFF}" >> some.file
  if [ ${DIFF} -gt ${THRESHOLD} ]; then
    #NC error
    echo "temp log is not updating" >> netcool.error
  else
    #set auto clear
    #NC Clear
    echo "temp log is updating. we are good" >> netcool.clear
  fi
done

