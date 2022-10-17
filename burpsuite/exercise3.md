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

