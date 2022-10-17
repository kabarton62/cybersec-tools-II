# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Burp Suite - Decoder and Comparer Tools; User and Proxy Options

## Build the Lab
Deploy a testing environment using Docker containers. A bash script that automates the deployment of the lab environment is provided [here](https://github.com/kabarton62/cybersec-tools-II/blob/main/burpsuite/exercise3-deploy.sh). Start by reviewing the bash script.
Lines 1 through 3 include the **shebang** and defome two variables, **$docker** and **$compose**. The shebang must be the first line.
```
#!/bin/bash
docker='/usr/bin/sudo /usr/bin/docker'
compose='/usr/bin/sudo /usr/bin/docker-compose'
```
The shebang declares the executable used to run the shell. With the shebang, the script could be given file permissions for execution and the script would execute using bash. Alternatively, the script could be executed with the bash command. See the two examples below.
```
# deploy.sh is not executable
user@server:~/burp3x$ ls -l
-rw-rw-r-- 1 kbarton kbarton 4782 Oct 17 14:44 deploy.sh

# change file permissions to make deploy.sh executable
user@server:~/burp3x$ chmod 755 deploy.sh 

# demonstrate that deploy.sh is executable
user@server:~/burp3x$ ls -l
-rwxr-xr-x 1 kbarton kbarton 4782 Oct 17 14:44 deploy.sh

# execute deploy.sh using two methods
user@server:~/burp3x$ ./deploy.sh
user@server:~/burp3x$ bash deploy.sh
```
Either technique will execute a bash script, but there is a nuanced difference between the two techniques. Executing the script with a bash command (bash deploy.sh) does not require the script to have execution permissions or the shebang in the script. The shebang is still useful to quickly identify the type of script, but it is not necessary to execute the script.

The variables $docker and $compose are used for simplicity. Docker and docker-compose require root privileges or a user in the docker group. Therefore, sudo is run with the docker and docker-compose commands throughout the script. Using full filepaths is a good security practice. The docker and docker-compose commands are used multiple times in the scripts. Defining variables for **/usr/bin/sudo /usr/bin/docker** and **/usr/bin/sudo /usr/bin/docker-compose** is completely optional but makes for a lot less typing.

Additional variables are defined for filenames, hostnames, and other details that are used throughout the script. Some of these variables are used multiple times. Defining variables reduces chances for errors and makes it easier to change these details at a later time. Variables must be defined before they are used. Placing them near the beginning of the script is not mandatory, but can help make the script easier to read.

```
f=docker-compose.yml
web='php:7.0-apache'
mysql='mysql:5'
wname='burp3-web'
hostname='chickenHouse'
sqlname='burp3-mysql'
sqlcommand='/usr/bin/mysql -u root -proot'
dir1='X8XFasTDNK'
dir2='softblue'
dir3='blue'
dir4='UTLanVxNGYZYL'
webip='172.19.4.3'
sqlip='172.19.4.4'
port='8500'
```

The last set of variables defines colors used to highlight text when the script runs. Specifically, these variables define the start and stop of red text when we print comments during script execution.

```
RED='\033[0;31m'
NC='\033[0m'
```

The script uses docker-compose to deploy two containers, a web server and a mysql server. Docker-compose requires a configuration file to deploy the containers and network. Although alternative filenames can be used, docker-compose looks for the file docker-compose.yml by default. The script uses a here-document to create docker-compose.yml. Notice that the docker-compose.yml file uses some of the variables defined at the beginning of the script, including container names, docker-compose.yml filename, port to bind http, and IP addresses for the containers. The mysql root user password is also defined in docker-compose.yml, and could be changed by modifying the enviroment value for MYSQL_ROOT_PASSWORD.

```
# Create docker-compose.yml
cat << EOF > $f
version: '2'
services:
 web:
   container_name: $wname
   image: $web
   hostname: $hostname
   depends_on:
    - mysql
   ports:
    - "$port:80"
   networks:
     burpbr:
       ipv4_address: $webip
 mysql:
   container_name: $sqlname
   image: $mysql
   environment: 
    - MYSQL_ROOT_PASSWORD=root
   networks: 
     burpbr:
       ipv4_address: $sqlip
networks:
  burpbr:
    driver: bridge
    ipam:
     config:
       - subnet: 172.19.4.0/24
         gateway: 172.19.4.1
EOF
```

The following command deploys the containers using docker-compose.
```
# Deploy the containers
$compose up -d 
```

Next, we create robots.txt with a here-document and copy it to the webroot in the web server.

```
# Create robots.txt and transfer to web server

cat << EOF > robots.txt
Ascii hex: so stupid
557365722d6167656e743a202a200a446973616c6c6f773a202f58385846617354444e4b2f
EOF

$docker cp robots.txt $wname:/var/www/html/robots.txt
```

Next, we install some packages in the web server (unzip, wget), download and extract File Thingie, and configure File Thingie. Note, the **printf** command is used to print a couple of comments showing actions being completed in the script. These are informational but could help us troubleshoot the script if we had problems executing the script.
```
# Prepare web server container. Install unzip, mysql-client, and download applications.
printf "\n${RED}Preparing the web server. Installing packages and applications.${NC}\n\n"

$docker exec -it $wname apt update 
$docker exec -it $wname apt install unzip wget -y
$docker exec -it $wname cd /
$docker exec -it $wname wget https://www.exploit-db.com/apps/71442de71ef46bf3ed53d416ec8bcdbd-filethingie-master.zip
$docker exec -it $wname unzip *.zip 
$docker exec -it $wname mv filethingie-master/ /var/www/html/$dir1/ 
$docker exec -it $wname rm 71442de71ef46bf3ed53d416ec8bcdbd-filethingie-master.zip 

# Configure filethingie index.php, admin user and password
printf "\n${RED}Configure File Thingie and create a password for the admin user.${NC}\n\n"

$docker exec -it $wname cp /var/www/html/$dir1/ft2.php /var/www/html/$dir1/index.php
$docker exec -it $wname cp /var/www/html/$dir1/config.sample.php /var/www/html/$dir1/config.php
$docker exec -it $wname sed -i 's/define("USERNAME", "")/define("USERNAME", "admin")/g' /var/www/html/$dir1/config.php
$docker exec -it $wname sed -i 's/define("PASSWORD", "")/define("PASSWORD", "24408ce3f09b31f9d3454ee6ea81bb63")/g' /var/www/html/$dir1/config.php
$docker exec -it $wname chown -R www-data:www-data /var/www/html/$dir1
```

The remainder of the script creates additional directories and index files for each directory, then copies those index files to each directory. Examples of two index files are shown below.

```
cat << EOF > webroot-index.html
<!DOCTYPE html>
<html>
<body>
<h2>Find things first</h2>
</body>
</html>
EOF

$docker cp webroot-index.html $wname:/var/www/html/index.html

cat << EOF > $dir2-index.html
<!DOCTYPE html>
<html>
<body>
<h2>base64</h2>
<p>Base64 Encoded: decode it.
UW1GelpUWTBJR2x6SUhOdklHVmhjM2tnZEc4Z1kzSmhZMnM9
</body>
</html>
EOF

$docker exec -it $wname mkdir /var/www/html/$dir2
$docker cp $dir2-index.html $wname:/var/www/html/$dir2/index.html
```
