#!/bin/bash

python ../bin/readConfig.py TargetServersInfo
. ./../lib/oacsyncfunc.sh
. ./../bin/TargetServersInfo.txt

echo -e "=============== start security import on $(hostname) at $(date +%H:%M) ===============\n" >> $masterlog

pw=$(echo "$pw" | openssl enc -aes-128-cbc -a -d -salt -pass pass:asdffdsa)
implogs="../logs/import"

echo -e "Import users started at $(date +%H:%M)\n" >> $masterlog
# Import groups into target OAC environment.
importGroups $un $pw $url $ImpSecDir 2>&1 | tee ${implogs}/groups/impGroups_$(date +%d-%b-%y_%H%M).log >> $masterlog
if [ "$?" -eq 0 ]
then
        echo -e "Import users on $(hostname) completed successfully at $(date +%H:%M)\n" >>$masterlog
else
        echo -e "Import users on $(hostname) failed at $(date +%H:%M)\n" >>$masterlog
fi

echo -e "Import groups started at $(date +%H:%M)\n" >> $masterlog
# Import users into target OAC environment.
importUsers $un $pw $url $ImpSecDir 2>&1 | tee ${implogs}/users/impUsers_$(date +%d-%b-%y_%H%M).log >> $masterlog
if [ "$?" -eq 0 ]
then
        echo -e "Import groups on $(hostname) completed successfully at $(date +%H:%M)\n" >>$masterlog
else
        echo -e "Import groups on $(hostname) failed at $(date +%H:%M)\n" >>$masterlog
fi
