import os
import sys

label_name = sys.argv[1]
#label2_name = sys.argv[2]
appNm = 'appNm'

file = open('../bin/' + sys.argv[1] + '.txt', 'w')

with open('../cfg/oacsyncconfig.cfg') as input_data:
    # Skips text before the beginning of the interesting block:
    for line in input_data:
        if line.strip() == (":" + label_name):  # Read file and find label passed as an parameter
            break
    # Reads text until the end of the block:
    for line in input_data:  # This keeps reading the file until blank line
        if line.strip() == '':
            break
        if appNm in line:
            subline=line.split("=")
	    appvar=(subline[0][4:])
	    if len(subline[1].split(",")) == 1:
		appval=(subline[1])
	    else:
                appval=(subline[1].replace(',',' '))
	else:
	    file.write(line[4:])
    file.write(appvar + "=" + "(" + appval[:-1] + ")")
