#!/bin/bash
. ./lib/font_style.sh
. ./lib/functions.sh

mainList
read num

case $num in
1)
	credentials
	fontface @b@blue[[Application Name to Export: ]]; read apps
	lcmExport $un $pw $url $apps
	;;
2)
	credentials
	fontface @b@blue[[Name of compressed file containing backup files along with path: ]]; read apps
	fontface @b@red[[Do you really want to import $filePath in $url? [y/n]: ]]; read opt
	if [ "$opt" == "y" -o "$opt" == "yes" ]; then
		lcmImport $un $pw $url $apps
	elif [ "$opt" == "n" -o "$opt" == "no" ]; then
		fontface @b@yellow[[Cancelled the import operation!]]
		printf "\n"
		exit 0
	else
		fontface @b@red[[Wrong Input..!]]
		printf "\n"
		exit 0
	fi	
	;;
3)
	subList1
	read num1
	case $num1 in
	1)		
		credentials
		getUsers $un $pw $server
		;;
	2)
		credentials
                getGroups $un $pw $server
                ;;
	*)
		fontface @b@red[[Invalid Choice!]]
        	printf "\n"
        	exit 0
		;;
	esac
        ;;
4)
	subList2
	read num2
	case $num2 in
       	1)
		credentials
         	importUsers $un $pw $server
         	;;
       	2)
		credentials
        	importGroups $un $pw $server
         	;;
	*)
                fontface @b@red[[Invalid Choice!]]
                printf "\n"
                exit 0
                ;;
     	esac
        ;;
*)
	fontface @b@red[[Invalid Choice!]]
	printf "\n"
	exit 0
	;;
esac
