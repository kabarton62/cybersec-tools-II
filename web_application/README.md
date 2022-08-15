# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Applications

## Download and extract WordPress
Download WordPress directly to your server using wget and extract the files from the archive. The web application is archived in a .zip file, so unzip will be required to extract the archive. The following commands will install unzip and download the archive from Exploit-DB.
```
sudo apt update && sudo apt install unzip
wget https://wordpress.org/latest.zip
```
Once you have a good copy of FileThingie 2.5.7, extract the files from the .zip archive. The directory Ticket-Booking-master/ will be extracted.
```
unzip latest.zip
```
Let's examine the contents of wordpress/ before we move forward.

```
$ ls -al wordpress/
total 212
-rw-r--r--  1 kbarton kbarton   405 Feb  6  2020 index.php
-rw-r--r--  1 kbarton kbarton 19915 Jan  1  2022 license.txt
-rw-r--r--  1 kbarton kbarton  7401 Mar 22 21:11 readme.html
-rw-r--r--  1 kbarton kbarton  7165 Jan 21  2021 wp-activate.php
drwxr-xr-x  9 kbarton kbarton  4096 Jul 12 16:16 wp-admin
-rw-r--r--  1 kbarton kbarton   351 Feb  6  2020 wp-blog-header.php
-rw-r--r--  1 kbarton kbarton  2338 Nov  9  2021 wp-comments-post.php
-rw-r--r--  1 kbarton kbarton  3001 Dec 14  2021 wp-config-sample.php
drwxr-xr-x  4 kbarton kbarton  4096 Jul 12 16:16 wp-content
-rw-r--r--  1 kbarton kbarton  3943 Apr 28 09:49 wp-cron.php
drwxr-xr-x 26 kbarton kbarton 12288 Jul 12 16:16 wp-includes
-rw-r--r--  1 kbarton kbarton  2494 Mar 19 20:31 wp-links-opml.php
-rw-r--r--  1 kbarton kbarton  3973 Apr 12 01:47 wp-load.php
-rw-r--r--  1 kbarton kbarton 48498 Apr 29 14:36 wp-login.php
-rw-r--r--  1 kbarton kbarton  8577 Mar 22 16:25 wp-mail.php
-rw-r--r--  1 kbarton kbarton 23706 Apr 12 09:26 wp-settings.php
-rw-r--r--  1 kbarton kbarton 32051 Apr 11 11:42 wp-signup.php
-rw-r--r--  1 kbarton kbarton  4748 Apr 11 11:42 wp-trackback.php
-rw-r--r--  1 kbarton kbarton  3236 Jun  8  2020 xmlrpc.php
```

wordpress/ contains 2 directories and 16 files. We see several files with extension **.php**. That suggests the application depends on PHP, so we will need to install PHP with our webserver. File readme.html confirms the requirement for PHP and MySQL or MariaDB.

We are building the applicaion on Linux, so we will build a LAMP (Linux, Apache, MySQL, PHP) server. 

Let's look at wp-config-sample.php before we start building our LAMP server. File wp-config-sample.php is a sample configuration file. Read the file with line numbers. Below is an extract of wp-config-sample.php that shows database settings. Note that we must provide a username, password and database name. 
```
cat wp-config-sample.php -n

 21  // ** Database settings - You can get this info from your web host ** //
    22  /** The name of the database for WordPress */
    23  define( 'DB_NAME', 'database_name_here' );
    24
    25  /** Database username */
    26  define( 'DB_USER', 'username_here' );
    27
    28  /** Database password */
    29  define( 'DB_PASSWORD', 'password_here' );
    30
    31  /** Database hostname */
    32  define( 'DB_HOST', 'localhost' );
    33
    34  /** Database charset to use in creating database tables. */
    35  define( 'DB_CHARSET', 'utf8' );
```

## Install Apache2, MySQL and PHP
Installation requires us to:
1. Create a database user and login 
2. Copy wp-config-sample.php to wp-config.php
3. Create a database
4. Update wp-config.php with the database name, username and password

In order to configure the database, we need to first install a database server. We've already run updates on our server, so now install Apache2, PHP and PHP modules, and MySQL server. 

```
# Install apache2. The -y option says to install apache2 without asking if you really want to install apache2.
sudo apt install -y apache2 

# Install php, php-cli, php-mysql and libapache2-mod-php. Libapache2-mod-php is needed if we have to manually enable PHP in Apache2. Php-cli is a PHP CLI utility.
sudo apt install -y php php-cli libapache2-mod-php php-mysql
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
Recall we need to prepare the server:
1. Create a mysql user
2. Create a database named **wp**
3. Create and ppdate wp-config.php with database name and mysql user's username & password

### Create mysql user and database
A **sql shell** is used to run sql querries in the MySQL server. The following commands:
1. Get a sql shell
2. Create a mysql user (username is wpuser, password is weakpass)
3. Create a database book
4. Grants privileges on database book to wpuser
5. Verifies database book was created

```
sudo mysql
mysql> CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'weakpass';
mysql> create database wp;
mysql> GRANT ALL PRIVILEGES ON wp.* TO 'wpuser'@'localhost';
mysql> show databases;
exit
```

Now, let's verify that **wpuser** can login to **wp**. Make sure that you have exited the first sql shell (root user). After successfully logging in, run **SELECT DATABASE()** to verify that you are using **wp** and **SELECT USER()** to show current user. All SQL queries should end with a semi-colon (;). 

```
mysql -u wpuser -p wp

Enter password: weakpass

mysql> SELECT DATABASE();
+------------+
| DATABASE() |
+------------+
| wp       |
+------------+
1 row in set (0.00 sec)

mysql> SELECT USER();
+--------------------+
| USER()             |
+--------------------+
| wpuser@localhost |
+--------------------+
1 row in set (0.00 sec)

mysql> 
```
### Copy wp-config-sample.php to wp-config.php
Exit the sql shell and create wp-config.php.
```
cp wordpress/wp-config.sample.php wordpress/wp-config.php
```
### Update wordpress/wp-config.php
Next, use a text editor such as nano or vim to edit db_login.php. Add the mysql user and password that you created and granted privileges to on database book.
```

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wp' );

/** Database username */
define( 'DB_USER', 'wpuser' );

/** Database password */
define( 'DB_PASSWORD', 'weakpass' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );
```
## Move the web application to a subdirectory in the webroot.
Last, move all content from wordpress/ to /var/www/html/wordpress/. Technically, we could deploy the application in the webroot itself, but moving the application to another directory will help understand how a single web server could host multiple websites or applications.
```
sudo mv wordpress/ /var/www/html/wordpress
sudo chown -R www-data:www-data /var/www/html/wordpress
ls -lR /var/www/html
```
## Set-up the WordPress site
Now, let's use a GUI-based browser to set-up WordPress. To do so, we need to either install a VPN or configure our GCP firewall to allow access to http from a trusted source. Ticket-Booking 1.4 is vulnerable. **DO NOT ALLOW HTTP ACCESS TO THE WORLD **.

### Prepare the GCP firewall
Grant http access only to trusted IP addresses. In this case, grant access to your home network's public IP, or some other trusted IP address.
1. Browse to ipchicken.com. Note your public IP address.
2. In GCP console, go to **VPC Network** > **Firewall** > **CREATE FIREWALL RULE**
3. Set the following parameters:
- Name: home-http
- Tagets: All instances in the network
- Source IPv4 ranges: YOUR PUBLIC IP
- Specified protocols and ports: TCP 80

## Install WordPress using the installation script
1. Determine the public IP address for your GCP instance and browse to **http://your-public-ip/wordpress**. You will be redirected to http://your-public-ip/wordpress/wp-admin/install.php. 
2. Click English (or whatever language you prefer) and follow the installation instructions.
3. **Make sure you save whatever username and password you create for the admin user.**
4. Follow the link to the login and login as your admin user. **Capture a screenshot of your admin Dashboard.**

## Digging a little deeper into MySQL
Recall that we created two users in this exercise. The MySQL user was wp and you created a WordPress admin user. The MySQL user is used by WordPress to bind to the MySQL server, the WordPress admin user is used to login to the WordPress application. Let's examine MySQL to understand where those user accounts are stored.

Get a mysql shell as root and look at the existing databases:
```
sudo mysql
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| wp                 |
+--------------------+
5 rows in set (0.01 sec)

mysql> 
```
The database mysql stores the credentials for MySQL user wp. The database wp stores the credentials for the WordPress admin user. Let's first find the MySQL user.
```
mysql> use mysql
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+------------------------------------------------------+
| Tables_in_mysql                                      |
+------------------------------------------------------+
| columns_priv                                         |
| component                                            |
| db                                                   |
| default_roles                                        |
| engine_cost                                          |
| func                                                 |
| general_log                                          |
| global_grants                                        |
| gtid_executed                                        |
| help_category                                        |
| help_keyword                                         |
| help_relation                                        |
| help_topic                                           |
| innodb_index_stats                                   |
| innodb_table_stats                                   |
| password_history                                     |
| plugin                                               |
| procs_priv                                           |
| proxies_priv                                         |
| replication_asynchronous_connection_failover         |
| replication_asynchronous_connection_failover_managed |
| replication_group_configuration_version              |
| replication_group_member_actions                     |
| role_edges                                           |
| server_cost                                          |
| servers                                              |
| slave_master_info                                    |
| slave_relay_log_info                                 |
| slave_worker_info                                    |
| slow_log                                             |
| tables_priv                                          |
| time_zone                                            |
| time_zone_leap_second                                |
| time_zone_name                                       |
| time_zone_transition                                 |
| time_zone_transition_type                            |
| user                                                 |
+------------------------------------------------------+
37 rows in set (0.00 sec)

mysql> show columns in user;
+--------------------------+-----------------------------------+------+-----+-----------------------+-------+
| Field                    | Type                              | Null | Key | Default               | Extra |
+--------------------------+-----------------------------------+------+-----+-----------------------+-------+
| Host                     | char(255)                         | NO   | PRI |                       |       |
| User                     | char(32)                          | NO   | PRI |                       |       |
--------------------------------------------------------------------------------------------------------------
| authentication_string    | text                              | YES  |     | NULL                  |       |
+--------------------------+-----------------------------------+------+-----+-----------------------+-------+

mysql> select user,host,authentication_string from user;
+------------------+-----------+------------------------------------------------------------------------+
| user             | host      | authentication_string                                                  |
+------------------+-----------+------------------------------------------------------------------------+
| debian-sys-maint | localhost | $A$005$k1@0<f,h        'SxpaiTEba/vT23mwTiKRgq2yL/VKXND0PyfSBLy0OkT1UUn7bI0 |
| mysql.infoschema | localhost | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED |
| mysql.session    | localhost | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED |
| mysql.sys        | localhost | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED |
| root             | localhost |                                                                        |
| wpuser           | localhost | $A$005$rZrauyOjx~N|-9n3nYHP9B7vwUIIzikD4CDy8hwwfA0OkiECiRtiCu/5 |
+------------------+-----------+------------------------------------------------------------------------+
6 rows in set (0.00 sec)
```

So, we see the wpuser credentials are stored in table **user** of database **mysql**. Now, let's find the WordPress admin credentials. Those credentials will be stored in the **wp** database, so let's drill into that database.

```
mysql> use wp;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-----------------------+
| Tables_in_wp          |
+-----------------------+
| wp_commentmeta        |
| wp_comments           |
| wp_links              |
| wp_options            |
| wp_postmeta           |
| wp_posts              |
| wp_term_relationships |
| wp_term_taxonomy      |
| wp_termmeta           |
| wp_terms              |
| wp_usermeta           |
| wp_users              |
+-----------------------+
12 rows in set (0.00 sec)

mysql> show columns in wp_users;
+---------------------+-----------------+------+-----+---------------------+----------------+
| Field               | Type            | Null | Key | Default             | Extra          |
+---------------------+-----------------+------+-----+---------------------+----------------+
| ID                  | bigint unsigned | NO   | PRI | NULL                | auto_increment |
| user_login          | varchar(60)     | NO   | MUL |                     |                |
| user_pass           | varchar(255)    | NO   |     |                     |                |
| user_nicename       | varchar(50)     | NO   | MUL |                     |                |
| user_email          | varchar(100)    | NO   | MUL |                     |                |
| user_url            | varchar(100)    | NO   |     |                     |                |
| user_registered     | datetime        | NO   |     | 0000-00-00 00:00:00 |                |
| user_activation_key | varchar(255)    | NO   |     |                     |                |
| user_status         | int             | NO   |     | 0                   |                |
| display_name        | varchar(250)    | NO   |     |                     |                |
+---------------------+-----------------+------+-----+---------------------+----------------+
10 rows in set (0.00 sec)

mysql> select user_login,user_pass from wp_users;
+------------+------------------------------------+
| user_login | user_pass                          |
+------------+------------------------------------+
| admin      | $P$B0/UtscN4tlhbHViXE.i.IRYS1p0kc. |
+------------+------------------------------------+
1 row in set (0.00 sec)

mysql> 
```
**Capture a screenshot of your Wordpress users**
