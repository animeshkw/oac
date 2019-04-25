#!/bin/bash

# ================= CLI Functions =================

login()
{
        esscs.sh login -url $url -u $un -p $pw
}

lcmExport()
{
	login
        esscs.sh lcmExport -v -a $apps -z $apps.zip -ld ../../files/apps -skip -o
	logout
}

lcmImport()
{
	login
        esscs.sh lcmImport -z $apps -o
	logout
}

logout(){ esscs.sh logout; }

# ================= CURL Functions =================

getUsers()
{
        curl -u $un:$pw $url/rest/v1/users > ../files/sec_export/users.csv
}

getGroups()
{
        curl -u $un:$pw $url/rest/v1/groups > ../files/sec_export/groups.csv
}

importUsers()
{
	curl -X POST -u $un:$pw -H "Accept: application/octet-stream" -H "Content-Type: application/octet-stream" $url/rest/v1/users --data-binary @$ImpSecDir/users.csv
}

importGroups()
{
	curl -X POST -u $un:$pw -H "Accept: application/octet-stream" -H "Content-Type: application/octet-stream" $url/rest/v1/groups --data-binary @$ImpSecDir/groups.csv
}
