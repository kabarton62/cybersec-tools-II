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

## Verify Apache2, MySQL and PHP are installed
Assuming you did not get errors, Apache2, MySQL and PHP should now be installed, but let's verify the services are installed and running. There are multiple ways to verify these services, but one quick way is to simply verify that TCP ports 80 (Apache2) and 3306 (MySQL) are LISTENing. This will require net-tools, which may not be installed. The following installs net-tools and uses netstat to look at listening services.
```
sudo apt install net-tools
sudo netstat -antp|grep LISTEN
  tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      81237/mysqld        
  tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      870/sshd: /usr/sbin 
  tcp6       0      0 :::80                   :::*                    LISTEN      23218/apache2       
```
