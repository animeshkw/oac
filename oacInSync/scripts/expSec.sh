#!/bin/bash

python ../bin/readConfig.py SourceServersInfo
. ./../lib/oacsyncfunc.sh
. ./../bin/SourceServersInfo.txt

echo -e "=============== start security export on $(hostname) at $(date +%H:%M) ===============\n" >> $masterlog

pw=$(echo "$pw" | openssl enc -aes-128-cbc -a -d -salt -pass pass:asdffdsa)
explogs="../logs/export"

echo -e "Export users started at $(date +%H:%M)\n" >> $masterlog
# Export users from source OAC server.
getUsers $un $pw $url 2>&1 | tee ${explogs}/users/expUsers_$(date +%d-%b-%y_%H%M).log >> $masterlog
if [ "$?" -eq 0 ]
then
        echo -e "Export users from $(hostname) completed successfully at $(date +%H:%M)\n" >>$masterlog
else
        echo -e "Export users from $(hostname) failed at $(date +%H:%M)\n" >>$masterlog
fi

echo -e "Export groups started at $(date +%H:%M)\n" >> $masterlog
# Export groups from source OAC server.
getGroups $un $pw $url 2>&1 | tee ${explogs}/groups/expGroups_$(date +%d-%b-%y_%H%M).log >> $masterlog
if [ "$?" -eq 0 ]
then
        echo -e "Export groups from $(hostname) completed successfully at $(date +%H:%M)\n" >>$masterlog
else
        echo -e "Export groups from $(hostname) failed at $(date +%H:%M)\n" >>$masterlog
fi
