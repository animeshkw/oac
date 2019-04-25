#!/bin/bash

python ../bin/readConfig.py TargetServersInfo
. ./../lib/oacsyncfunc.sh
. ./../bin/TargetServersInfo.txt

echo "=============== start application import on $(hostname) at $(date +%H:%M) ===============" >> $masterlog

pw=$(echo "$pw" | openssl enc -aes-128-cbc -a -d -salt -pass pass:asdffdsa)
lwd=`dirname $(pwd)`
implogs=${lwd}/logs/import/appl

if [ "${#appNm[@]}" -eq 1 ]; then
        app=${appNm[@]}
        dt=$(date +%d-%b-%y_%H%M)
	apps="${AppDir}/${app}.zip"
	echo "Import application $app started at $(date +%H:%M)" | tee -a ${implogs}/${app}_${dt}.log >> $masterlog
        lcmImport $apps | tee -a ${implogs}/${app}_${dt}.log >> $masterlog
	if [ "$?" -eq 0 ]
	then
		echo -e "Import application $app completed successfully at $(date +%H:%M)\n" | tee -a ${implogs}/${app}_${dt}.log >> $masterlog
	else
		echo -e "Import application $app failed at $(date +%H:%M)\n" | tee -a ${implogs}/${app}_${dt}.log >> $masterlog
	fi
elif [ "${#appNm[@]}" -gt 1 ]; then
	for app in ${appNm[*]}
        do
                dt=$(date +%d-%b-%y_%H%M)
                apps="${AppDir}/${app}.zip"
		echo "Import application $app started at $(date +%H:%M)" | tee -a ${implogs}/${app}_${dt}.log >> $masterlog
                lcmImport $apps | tee -a ${implogs}/${app}_${dt}.log >> $masterlog
		if [ "$?" -eq 0 ]
        	then
                	echo -e "Import application $app completed successfully at $(date +%H:%M)\n" | tee -a ${implogs}/${app}_${dt}.log >> $masterlog
        	else
                	echo -e "Import application $app failed at $(date +%H:%M)\n" | tee -a ${implogs}/${app}_${dt}.log >> $masterlog
        	fi
        done
else
        echo "Please provide atleast one application name to import"
fi
