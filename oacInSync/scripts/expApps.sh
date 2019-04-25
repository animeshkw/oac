#!/bin/bash

python ../bin/readConfig.py SourceServersInfo
. ./../lib/oacsyncfunc.sh
. ./../bin/SourceServersInfo.txt

echo "=============== start application export on $(hostname) at $(date +%H:%M) ===============" >> $masterlog

pw=$(echo "$pw" | openssl enc -aes-128-cbc -a -d -salt -pass pass:asdffdsa)
lwd=`dirname $(pwd)`
explogs="${lwd}/logs/export"

for appfile in ../files/apps/*.zip; do
  tmstmp=`date -r $appfile "+%d-%b-%Y_%H%M"`
  fd1=`echo ${appfile##*/} | cut -f1 -d'.'`
  fd2=`echo ${appfile##*/} | cut -f2 -d'.'`
  cp -p $appfile ../files/apps/archive/${fd1}_${tmstmp}.${fd2}
done

for secfile in ../files/sec_export/*.csv; do
  tmstmp=`date -r $secfile "+%d-%b-%Y_%H%M"`
  fd1=`echo ${secfile##*/} | cut -f1 -d'.'`
  zip -j ../files/sec_export/archive/${fd1}_${tmstmp}.zip $secfile
done

# Retain application and security export backup older then number of days passed in parameter.
find ../files/apps/archive/ -type f -mtime +${appKeepBkp} -exec rm {} \;
find ../files/sec_export/archive/ -name "*.zip" -type f -mtime +${secKeepBkp} -exec rm {} \;
find ../logs/* -name "*.log" -type f -mtime +${logKeepBkp} -exec rm {} \;

echo ${appNm[*]}

if [ "${#appNm[@]}" -eq 1 ]; then
        apps=${appNm[@]}
        dt=$(date +%d-%b-%y_%H%M)
	echo "Export application $app started at $(date +%H:%M)" | tee -a ${explogs}/appl/${apps}_${dt}.log >>$masterlog
        lcmExport $apps | tee -a ${explogs}/appl/${apps}_${dt}.log >>$masterlog
	if [ "$?" -eq 0 ]
        then
                echo -e "Export application $apps completed successfully at $(date +%H:%M)\n" | tee -a ${explogs}/appl/${apps}_${dt}.log >>$masterlog
        else
                echo -e "Export application $apps failed at $(date +%H:%M)\n" | tee -a ${explogs}/appl/${apps}_${dt}.log >>$masterlog
        fi
elif [ "${#appNm[@]}" -gt 1 ]; then
        for app in ${appNm[*]}
        do
                dt=$(date +%d-%b-%y_%H%M)
		apps="$app"
		echo "Export application $app started at $(date +%H:%M)" | tee -a ${explogs}/appl/${apps}_${dt}.log >>$masterlog
                lcmExport $apps | tee -a ${explogs}/appl/${apps}_${dt}.log >>$masterlog
		if [ "$?" -eq 0 ]
        	then
                	echo -e "Export application $apps completed successfully at $(date +%H:%M)\n" | tee -a ${explogs}/appl/${apps}_${dt}.log >>$masterlog
        	else
                	echo -e "Export application $apps failed at $(date +%H:%M)\n" | tee -a ${explogs}/appl/${apps}_${dt}.log >>$masterlog
        	fi
	done
else
        echo "Please provide atleast one application name to export"
fi
