Download help:
-------------
1. Install jdk1.8 and set JAVA_HOME environment variable to point to the jdk1.8 folder

2. Download 'cli.zip' and place into local windows directory

3. Unzip 'cli.zip' and following is the exploded folder structure
		- cli
			- lib
			- esscs.bat (launch cli)
			- esscs.sh (launch cli in linux)
			- readme.txt 
            - cert_esscs.crt (certificate for secure connection)

4. set password for a user
        Example:
        esscs setpassword -user weblogic -url http://<host>:<port>/essbase (insecure connection)
        esscs setpassword -user weblogic -url https://<host>:<sslport>/essbase (secure connection)
        
5. login esscs
   If secure connection is required, the url should start with https. 
        Example:
        esscs login -user weblogic -url http://<host>:<port>/essbase (insecure connection)
        esscs login -user weblogic -url https://<host>:<sslport>/essbase (secure connection)
        			
6. Try commands after login
        Example:  
        esscs calc -application Sample -db Basic -script CALCALL.CSC
        < more commands ...>
        
7. logout        
        esscs logout 


Use 'esscs -help' to get list of supported commands.
Use 'esscs <commandName> -help' to get command specific help and usage

Use -v option for verbose output(if available) for any command

