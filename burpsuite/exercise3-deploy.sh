#!/bin/bash
docker='/usr/bin/sudo /usr/bin/docker'
compose='/usr/bin/sudo /usr/bin/docker-compose'
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
hashf='84d961568a65073a3bcf0eb216b2a576'
webip='172.19.4.3'
sqlip='172.19.4.4'
port='8500'
RED='\033[0;31m'
NC='\033[0m'

/usr/bin/sudo /usr/bin/apt update
/usr/bin/sudo /usr/bin/apt install docker-compose -y

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

# Deploy the containers
$compose up -d 

# Create robots.txt and transfer to web server

cat << EOF > robots.txt
Ascii hex: so stupid
557365722d6167656e743a202a200a446973616c6c6f773a202f58385846617354444e4b2f
EOF

$docker cp robots.txt $wname:/var/www/html/robots.txt

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

cat << EOF > $dir3-index.html
<!DOCTYPE html>
<html>
<body>

<h2>Encoding</h2>
<p>URL Encoded: decode it.
%48%54%4d%4c%20%45%6e%63%6f%64%65%64%3a%20%64%65%63%6f%64%65%20%69%74%2e%0a%26%23%78%34%32%3b%26%23%78%36%31%3b%26%23%78%37%33%3b%26%23%78%36%35%3b%26%23%78%33%36%3b%26%23%78%33%34%3b%26%23%78%33%61%3b%26%23%78%32%30%3b%26%23%78%36%34%3b%26%23%78%36%35%3b%26%23%78%36%33%3b%26%23%78%36%66%3b%26%23%78%36%34%3b%26%23%78%36%35%3b%26%23%78%32%30%3b%26%23%78%36%39%3b%26%23%78%37%34%3b%26%23%78%32%65%3b%26%23%78%30%61%3b%26%23%78%35%32%3b%26%23%78%36%64%3b%26%23%78%36%63%3b%26%23%78%37%35%3b%26%23%78%35%39%3b%26%23%78%35%37%3b%26%23%78%37%38%3b%26%23%78%37%33%3b%26%23%78%36%35%3b%26%23%78%35%33%3b%26%23%78%37%37%3b%26%23%78%36%37%3b%26%23%78%35%39%3b%26%23%78%35%33%3b%26%23%78%34%32%3b%26%23%78%33%33%3b%26%23%78%36%31%3b%26%23%78%35%37%3b%26%23%78%33%34%3b%26%23%78%36%38%3b
</body>
</html>

EOF
$docker exec -it $wname mkdir /var/www/html/$dir3
$docker cp $dir3-index.html $wname:/var/www/html/$dir3/index.html

cat << EOF > $dir4-index.html
<!DOCTYPE html>
<html>
<body>

<h2>Not so Mystery Encoding</h2>
<p>VGhlIEZpbGUgVGhpbmdpZSBhZG1pbiB0aG91Z2h0IGl0IHdvdWxkIGJlIGNsZXZlciB0byBzdG9yZSB0aGUgcGFzc3dvcmQgYXMgYW4gbWQ1IGhhc2guIFRoZSB0aGluZyBpcyB0aG91Z2gsIEZpbGUgVGhpbmdpZSBkb2Vzbid0IGhhc2ggcGxhaW50ZXh0IHBhc3N3b3JkcyBkdXJpbmcgYXV0aGVudGljYXRpb24u</p>

</body>
</html>
EOF

$docker exec -it $wname mkdir /var/www/html/$dir4
$docker cp $dir4-index.html $wname:/var/www/html/$dir4/$hashf.html

cat << EOF > customWordlist.txt
celtic
barcelona
celeste
marcela
jocelyn
celticfc
darling
darkangel
darren
darkness
darwin
darius
flower
flowers
florida
flores
sunflower
flower1
flower
flowers
florida
flores
flower1
rockstar
superstar
starwars
stars
starlight
superman
amanda
samantha
manuel
batman
spiderman
manutd
manchester
emmanuel
armando
tazmania
amanda1
superman1
emanuel
norman
iceman
EOF

