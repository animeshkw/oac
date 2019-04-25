#!/bin/bash

# move master logs to archive directory, if exist.
path=`dirname $(pwd)`
logfile=${path}/logs/oacInSync_*.log
if [ -f $logfile ]; then
	mv $logfile ${path}/logs/archive/.
fi

# Remove logs and report files older then 15 days.
find ${path}/logs/archive/ -name "*.log" -type f -mtime +15 -exec rm {} \;
find ${path}/logs/reports/ -name "*.txt" -type f -mtime +15 -exec rm {} \;

export masterlog=${path}/logs/oacInSync_$(date +"%d-%b-%Y_%H%M").log

( exec ./expSec.sh )
wait

( exec ./expApps.sh )
wait

( exec ./impSec.sh )
wait

( exec ./impApps.sh )
wait

python ../bin/createReport.py $masterlog
