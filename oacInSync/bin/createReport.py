import os
import sys

log_name = sys.argv[1]
file = open('../logs/reports/' + 'oacInsync.txt', 'w')

def secRep(line, str):
    if ("Export " + str + " started at") in line:
        file.write("Artifact Name: " + (line.split()[1]) + "\n")
        file.write("Process Name: " + (line.split()[0]) + "\n")
        file.write("Start Time: " + (line.split()[4]) + "\n")
    elif ("Export " + str + " from") in line:
        file.write("End Time: " + (line.split()[7]) + "\n")
        file.write("Elapsed Time: " + (line.split()[7]) + "\n")
        file.write("Server Name: " + (line.split()[3]) + "\n")
        file.write("Status: " + (line.split()[4]) + "\n")
        file.write("=========================================\n")
    elif ("Import " + str + " started at") in line:
        file.write("Artifact Name: " + (line.split()[1]) + "\n")
        file.write("Process Name: " + (line.split()[0]) + "\n")
        file.write("Start Time: " + (line.split()[4]) + "\n")
    elif ("Import " + str + " on") in line:
        file.write("End Time: " + (line.split()[7]) + "\n")
        file.write("Elapsed Time: " + (line.split()[7]) + "\n")
        file.write("Server Name: " + (line.split()[3]) + "\n")
        file.write("Status: " + (line.split()[4]) + "\n")
        file.write("=========================================\n")

def appRep(line, str):
    if ("Export application " + str + " started at") in line:
        file.write("Application Name: " + (line.split()[2]) + "\n")
        file.write("Process Name: " + (line.split()[0]) + "\n")
        file.write("Start Time: " + (line.split()[5]) + "\n")
    elif "Export application " + str + " completed successfully at" in line:
        file.write("End Time: " + (line.split()[6]) + "\n")
        file.write("Elapsed Time: " + (line.split()[6]) + "\n")
        file.write("Status: " + (line.split()[3]) + "\n")
        file.write("=========================================\n")
    elif ("Import application " + str + " started at") in line:
        file.write("Application Name: " + (line.split()[2]) + "\n")
        file.write("Process Name: " + (line.split()[0]) + "\n")
        file.write("Start Time: " + (line.split()[5]) + "\n")
    elif "Import application " + str + " completed successfully at" in line:
        file.write("End Time: " + (line.split()[6]) + "\n")
        file.write("Elapsed Time: " + (line.split()[6]) + "\n")
        file.write("Status: " + (line.split()[3]) + "\n")
        file.write("=========================================\n")

def extractLines(file, startStr, endStr, srchStr):
    with open(file) as input_data:
        # Skips text before the beginning of the interesting block:
        for line in input_data:
            if startStr in line:  # Or whatever test is needed
                break
        # Reads text until the end of the block:
        for line in input_data:  # This keeps reading the file
            if endStr in line:
                break
            #print (line)  # Line is extracted
            if srchStr == "users" or srchStr == "groups":
                secRep(line, srchStr)
            elif srchStr == "Sample" or srchStr == "Sample_R":
                appRep(line, srchStr)

extractLines(log_name, '=============== start security export', '=============== start application export', 'users')
extractLines(log_name, '=============== start security export', '=============== start application export', 'groups')
extractLines(log_name, '=============== start application export', '=============== start security import', 'Sample')
extractLines(log_name, '=============== start application export', '=============== start security import', 'Sample_R')
extractLines(log_name, '=============== start security import', '=============== start application import', 'users')
extractLines(log_name, '=============== start security import', '=============== start application import', 'groups')
extractLines(log_name, '=============== start application import', '\0', 'Sample')

