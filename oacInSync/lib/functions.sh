#!/bin/bash

# ================= Basic Functions ===============

credentials()
{
        fontface @b@cyan[[Please login to OAC Essbase server..]]
        printf "\n"
        fontface @b@blue[[Username: ]]; read un
        stty -echo; fontface @b@blue[[Password: ]]; read pw; stty echo; printf "\n"
	fontface @b@blue[[Server Name in following format http://servername:9000/essbase :]]; read url
}

mainList()
{
	fontface @b@cyan[[Please make your choice.]]
	echo -e "
1. Export Application LCM Backup.
2. Import Application LCM Backup.
3. Export OAC Users/Groups.
4. Import Users/Groups.\n"
}

subList1()
{
        fontface @b@cyan[[Please Select option :]]
        echo -e "
        1. Export Users.
        2. Export Groups.\n"
}

subList2()
{
	fontface @b@cyan[[Please Select option :]]
	echo -e "
	1. Import Users.
	2. Import Groups.\n"
}

# ================= CLI Functions =================

login()
{
        esscs.sh login -url $url -u $un -p $pw
}

logout(){ esscs.sh logout; }

lcmExport()
{
        login
        esscs.sh lcmExport -v -a $apps -z $apps.zip -ld ../../files/apps -skip -o
        logout
}

lcmImport()
{
        #login
        esscs.sh lcmImport -z $apps -o
        #logout
}

# ================= CURL Functions =================

getUsers()
{
        curl -u $un:$pw $url/rest/v1/users > users.csv
        mv users.csv files/sec_export
}

getGroups()
{
        curl -u $un:$pw $url/rest/v1/groups > groups.csv
        mv groups.csv files/sec_export
}

importUsers()
{
	curl -X POST -u $un:$pw -H "Accept: application/octet-stream" -H "Content-Type: application/octet-stream" $url/rest/v1/users --data-binary @files/sec_import/users.csv > logs/ImportUsers.log
}

importGroups()
{
	curl -X POST -u $un:$pw -H "Accept: application/octet-stream" -H "Content-Type: application/octet-stream" $url/rest/v1/groups --data-binary @files/sec_import/users.csv > logs/ImportGroups.log
}
