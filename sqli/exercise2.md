# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Introduction to SQL injection (SQLi)

## Deploy a SQLi Lab

### Challenge 1: DVWA
1. Start a Metasploitable2 Docker container and browse to DVWA. 
2. Login with the default credentials **admin**/**password**.
3. Set **DVWA Security** to **Low**.
4. Select **SQL Injection**.

Figure 1 illustrates DVWA security set to low.

<img src="../images/sqli_1_start.png" width="800" height="900">

**Figure 1, DVWA**

## Discover SQLi Vulnerability

### Challenge 2: Finding the SQL Injection Point

The SQL Injection point is the HTTP header, GET/POST request parameter, or other user input field where an attacker can escape a structured SQL statement and create their own SQL statement. If an attacker is lucky, a SQL injection point can be discovered by creating a syntax error that forces a SQL error. Receiving a SQL error from is a strong indicator of a SQLi vulnerability. Therefore, a best practice for web developers is to suppress SQL errors. Suppressing SQL errors does not by itself defend against SQLi attacks, but it does increase the work required to successfully execute a SQLi attack.

DVWA does not suppress SQL errors in the Low security setting. Therefore, we can demonstrate the existence of a SQLi vulnerability by forcing a SQL error. Note that user input entered in the form is reflected in the URL, as shown in Figure 2. The URL could be modified to test for SQLi vulnerability.

<img src="../images/sqli_2_URL.png" width="800" height="900">

**Figure 2, User Input in the URL**

Figure 3 shows a SQL error returned to the web application. A single-quotation mark was passed in the _id_ parameter and returned a SQL error. This indicates that a single-quotation mark can be used to escape the scripted SQL statement and that likely an attacker could craft their own SQL statement. This is the _SQL Injection point_.

<img src="../images/sqli_3_sqlError.png" width="800" height="900">

**Figure 3, SQL Error Indicating SQL Injection Point**

### Challenge 3: Injecting a Malicious SQL Statement
Once a tester discovers a SQL injection point, the next step is demonstrating the ability inject a malicious SQL statement. Common strings include TRUE condition SQL OR statements appended to the escape character (i.e, " or '). Some applications may prohibit spaces, text strings such as OR, or use other controls to reduce exposure to SQLi attacks. Following or different iterations of the same TRUE condition OR statement: **OR 1=1**.

```
or 1=1
or '1=1
or '1'='1
or '1'='1'
or 1=1#
or '1=1'#
or '1'='1'#
or 1=1;#
or '1=1';#
or '1'='1';#
||1=1
||'1=1
||'1'='1
||'1'='1'
||1=1#
||'1=1'#
||'1'='1'#
||1=1;#
||'1=1';#
||'1'='1';#
or/**/1=1
or/**/'1=1
or/**/'1'='1
or/**/'1'='1'
or/**/1=1#
or/**/'1=1'#
or/**/'1'='1'#
or/**/1=1;#
or/**/'1=1';#
or/**/'1'='1';#
```
DVWA is vulnerable to a simple OR statement and will disclose all users. Figure 4 shows a succcessful SQLi attack using the string **'OR '1=1**.

<img src="../images/sqli_4_sqiiProof.png" width="800" height="900">

**Figure 4, SQLi Proof**


**Capture a screenshot showing a successful SQLi attack against DVWA that discloses application users using a string other than "'OR '1=1".**

