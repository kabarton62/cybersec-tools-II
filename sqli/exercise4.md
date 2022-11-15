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
