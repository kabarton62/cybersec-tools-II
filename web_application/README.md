# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Applications

## Download and extract Ticket-Booking 1.4
Download Ticket-Booking 1.4 from Exploit-DB directly to your server using wget and extract the files from the archive. The web application is archived in a .zip file, so unzip will be required to extract the archive. The following commands will install unzip and download the archive from Exploit-DB.
```
sudo apt update && sudo apt install unzip
wget https://www.exploit-db.com/apps/4a98716b169f2e384c3b7ca4f0432f4a-Ticket-Booking-master.zip
```
Note that 4a98716b169f2e384c3b7ca4f0432f4a-Ticket-Booking-master.zip was downloaded. 4a98716b169f2e384c3b7ca4f0432f4a in the filename is not random, it is the md5 hash value for the file. We can verify that our download was not corrupted by verifying file's hash against this value.
```
md5sum 4a98716b169f2e384c3b7ca4f0432f4a-Ticket-Booking-master.zip
```
A hash value of 4a98716b169f2e384c3b7ca4f0432f4a validates a good copy was downloaded. Any other result means the download is corrupt and the application should be downloaded again.

Once you have a good copy of Ticket-Booking 1.4, extract the files from the .zip archive. The directory Ticket-Booking-master/ will be extracted.
```
unzip 4a98716b169f2e384c3b7ca4f0432f4a-Ticket-Booking-master.zip
```
Let's examine the contents of Ticket-Booking-master/ before we move forward.

```
$ ls -al Ticket-Booking-master/
total 84
drwxrwxr-x 6 kbarton kbarton 4096 Jun 22  2016 .
drwxr-xr-x 7 kbarton kbarton 4096 Aug 15 16:45 ..
-rw-rw-r-- 1 kbarton kbarton  483 Jun 22  2016 .gitattributes
-rw-rw-r-- 1 kbarton kbarton 2643 Jun 22  2016 .gitignore
-rw-rw-r-- 1 kbarton kbarton 1492 Jun 22  2016 Readme.txt
-rw-rw-r-- 1 kbarton kbarton 5737 Jun 22  2016 book.php
-rw-rw-r-- 1 kbarton kbarton 4761 Jun 22  2016 cancel.php
-rw-rw-r-- 1 kbarton kbarton 2349 Jun 22  2016 cancelled.php
drwxrwxr-x 2 kbarton kbarton 4096 Jun 22  2016 css
drwxrwxr-x 2 kbarton kbarton 4096 Jun 22  2016 database
-rw-rw-r-- 1 kbarton kbarton  784 Jun 22  2016 db_login.php
drwxrwxr-x 2 kbarton kbarton 4096 Jun 22  2016 img
-rw-rw-r-- 1 kbarton kbarton 3422 Jun 22  2016 index.php
drwxrwxr-x 2 kbarton kbarton 4096 Jun 22  2016 js
-rw-rw-r-- 1 kbarton kbarton 3096 Jun 22  2016 login.php
-rw-rw-r-- 1 kbarton kbarton 4682 Jun 22  2016 register.php
-rw-rw-r-- 1 kbarton kbarton 4539 Jun 22  2016 seat.php
```

Ticket-Booking-master/ contains 4 directories and 11 files. Two files (.gitattributes and .gitignore) are hidden files used for a Git repository. We are not interested in those file. We see several files with extension **.php**. That suggests the application depends on PHP, so we will need to install PHP with our webserver. Readme files often include installation instructions, so let's start there. **Read Ticket-Booking-master/Readme.txt**.

```
Steps to set up this website in WAMP.

1) Create user in WAMP.
eg.
grant all privileges on *.* to 'abhijeet'@localhost identified by 'abhijeet';
Note: Change the username & password in db_login.php according to your username & password.


2) Create database with name 'book'.

3) Import tables in 'book' database. Go to import tab in WAMP & give path of below file to import.
Ticket-Booking\database\book.sql

4) Please replace below email to email of your website admin, so that admin will receive email on every seat book.
File: Ticket-Booking/register.php
Replce below
mail ("openingknots@gmail.com", "New ticket booked", $email_content);

By
mail ("admin-email@gmail.com", "New ticket booked", $email_content);
5) Done.
```
**WAMP** is Apache, MySQL and PHP on Windows. We are building the applicaion on Linux, not Windows, so we will build a LAMP (Linux, Apache, MySQL, PHP) server instead of a WAMP server. 

## Install Apache2, MySQL and PHP
The installation instructions tell us to:
1. Create a database user and login 
2. Update db_login.php with the database username and password
3. Create a database named _book_
4. Import the tables for db _book_ from _Ticket-Booking\database\book.sql_

In order to configure the database, we need to first install a database server. We've already run updates on our server, so now install Apache2, PHP and PHP modules, and MySQL server. 
```
# Install apache2. The -y option says to install apache2 without asking if you really want to install apache2.
sudo apt install -y apache2 

# Install php, php-cli and libapache2-mod-php. Libapache2-mod-php is needed if we have to manually enable PHP in Apache2. Php-cli is a PHP CLI utility.
sudo apt install -y php php-cli libapache2-mod-php 
sudo systemctl restart apache2

# Install mysql-server.
sudo apt install -y mysql-server
```

## Verify that Apache2, MySQL and PHP are installed and running
Assuming you did not get errors, Apache2, MySQL and PHP should now be installed, but let's verify the services are installed and running. There are multiple ways to verify these services, but one quick way is to simply verify that TCP ports 80 (Apache2) and 3306 (MySQL) are LISTENing. This will require net-tools, which may not be installed. The following installs net-tools and uses netstat to look at listening services.
```
sudo apt install net-tools
sudo netstat -antp|grep LISTEN
  tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      81237/mysqld        
  tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      870/sshd: /usr/sbin 
  tcp6       0      0 :::80                   :::*                    LISTEN      23218/apache2       
```

On Ubuntu and most Debian-based web servers will use /var/www/html as the default webroot. The webroot shoud currently have the default Apache2 index.html. Verify that by examining the webroot content and browsing to http://localhost. 
```
ls /var/www/html
  drwxr-xr-x 3 root    root     4096 Aug 10 19:23 .
  drwxr-xr-x 3 root    root     4096 Aug 10 19:21 ..
  -rw-r--r-- 1 root    root    10918 Aug 10 19:21 index.html

curl http://localhost

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <!--
    Modified from the Debian original for Ubuntu
    Last updated: 2016-11-16
    See: https://launchpad.net/bugs/1288690
  -->
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Apache2 Ubuntu Default Page: It works</title>
    <style type="text/css" media="screen">
 ------ TRUNCATED -----   
 ```
This demonstrates that:
 - MySQL TCP 3306 is listening and bound to the loopback interface (127.0.0.1)
 - Apache2 is listening and serving the default Apache2 page on TCP 80

We do not know the status of php, so let's test it. The following commands:
1. Delete the default Apache2 page from the webroot
2. Changes user to root so you can create a file in the webroot
3. Creates a new index page (index.php) in the webroot
4. Adds a PHP script to index.php that renders detailed information on the PHP installation
5. Exits root user

```
sudo rm /var/www/html/index.html
sudo su
echo "<?php phpinfo(); ?>" > /var/www/html/index.php
exit
```
If you read /var/www/html/index.php, it will have just a single line of code. However, that single line will return a full page of data through a browser **if PHP is enabled in Apache2**, but just the string <?php phpinfo(); ?> if PHP is not enabled. Verify that PHP is enabled by browsing to the localhost.

PHP enabled in Apache2 will look like:
```
curl localhost

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<style type="text/css">
body {background-color: #fff; color: #222; font-family: sans-serif;}
pre {margin: 0; font-family: monospace;}
a:link {color: #009; text-decoration: none; background-color: #fff;}
a:hover {text-decoration: underline;}
table {border-collapse: collapse; border: 0; width: 934px; box-shadow: 1px 2px 3px #ccc;}
.center {text-align: center;}
.center table {margin: 1em auto; text-align: left;}
.center th {text-align: center !important;}
td, th {border: 1px solid #666; font-size: 75%; vertical-align: baseline; padding: 4px 5px;}
th {position: sticky; top: 0; background: inherit;}
h1 {font-size: 150%;}
h2 {font-size: 125%;}
.p {text-align: left;}
.e {background-color: #ccf; width: 300px; font-weight: bold;}
.h {background-color: #99c; font-weight: bold;}
.v {background-color: #ddd; max-width: 300px; overflow-x: auto; word-wrap: break-word;}
.v i {color: #999;}

------ TRUNCATED -------

```

## Prepare database
Recall that Readme.txt instructed us to:
1. Create a mysql user
2. Create a database named **book**
3. Import tables into database **book**
4. Update db_login.php with mysql user's username & password

### Create mysql user and database
A **sql shell** is used to run sql querries in the MySQL server. The following commands:
1. Get a sql shell
2. Create a mysql user (username is bookuser, password is weakpass)
3. Create a database book
4. Grants privileges on database book to bookuser
5. Verifies database book was created

```
sudo mysql
mysql> CREATE USER 'bookuser'@'localhost' IDENTIFIED BY 'weakpass';
mysql> create database book;
mysql> GRANT ALL PRIVILEGES ON book.* TO 'bookuser'@'localhost';
mysql> show databases;
exit
```

Now, let's verify that **bookuser** can login to **book**. Make sure that you have exited the first sql shell (root user). After successfully logging in, run **SELECT DATABASE()** to verify that you are using **book** and **SELECT USER()** to show current user. All SQL queries should end with a semi-colon (;). 

```
mysql -u bookuser -p book

Enter password: weakpass

mysql> SELECT DATABASE();
+------------+
| DATABASE() |
+------------+
| book       |
+------------+
1 row in set (0.00 sec)

mysql> SELECT USER();
+--------------------+
| USER()             |
+--------------------+
| bookuser@localhost |
+--------------------+
1 row in set (0.00 sec)

mysql> 
```
### Import tables to database book
Exit the sql shell and import tables into database book from Ticket-Booking-master/database/book.sql. Then verify that the tables were imported to the database.
```
mysql -u bookuser -p book < Ticket-Booking-master/database/book.sql

mysql -u bookuser -p book
mysql> show tables;
+----------------+
| Tables_in_book |
+----------------+
| register       |
| seat           |
+----------------+
2 rows in set (0.00 sec)
```
### Update Ticket-Booking-master/db_login.php
```
nano Ticket-Booking-master/db_login.php

  GNU nano 4.8                                                                            Ticket-Booking-master/db_login.php                                                                                      
<!--

<Ticket-Booking>
Copyright (C) <2013>  
<Abhijeet Ashok Muneshwar>
<openingknots@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
 any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

-->

<?php
        $db_host='localhost';
        $db_username='bookuser';
        $db_password='weakpass';
?>
