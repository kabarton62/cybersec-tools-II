# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Application Enumeration - Vulnerability Scans

## Web application vulnerability scanning
The National Institute of Standards and Technology (NIST) defines [vulnerability](https://csrc.nist.gov/glossary/term/vulnerability) as a "weakness in a system, system security procedures, internal controls, or implementation that could be exploited or triggered by a threat." A vulnerability could be a weakness such as a software bug, failure to properly implement a control or countermeasure used to remediate some weakness, a workflow weakness, a weak configuration, or other weaknesses. There is a common tendency to recognize software flaws as sources of vulnerabilities, but to not consider other sources such as configuration errors. While developers generally provide patches to fix software vulnerabilites, there is no such equivalent to **patching** for configuration errors. So, let's take a deeper look at the idea of configuration errors.

### Configuration errors
A **configuration error** is a condition, setting or parameter that creates a vulnerability or interrupts system operation. We are concerned with configuration errors that create vulnerabilities. Consider the following example to better understand configuration errors and their relationship to vulnerabilities.

File Transfer Protocol (ftp) is used to transfer files between an ftp server and ftp client. An ftp server can be configured in many different ways, to include requiring users to authenticate, not requiring authentication, or allowing annonymous authentication. Depending on the purpose of the ftp server, any of those configurations could be safe and secure. For example, if an ftp server is used to collect data or files from untrusted users, then unauthenticated or annonymous login might make sense. However, configuring the ftp server to allow untrusted access to any directory on the server would be a serious vulnerability.

In this scenario, the software for the ftp server itself does not have vulnerabilities, but the _configuration of the ftp server_ is vulnerable. The ftp server's configuration error cannot be remediated with a patch. Fixing the vulnerability requires system administrators to change the server's configuration, such as properly restricting access to directories that would be safe for untrusted users to access.

### Vulnerability scanning
[Vulnerability scanning](https://csrc.nist.gov/glossary/term/vulnerability_scanning) identifies host attributes to detect vulnerabilities. Although a vulnerability scanner could be run internally on the target host/server, most vulnerability scanners are network tools used to scan network devices to identify documented vulnerabilities. Network vulnerability scanners send requests to network devices to detect behavior that fingerprints the existence of vulnerabilities.

In our ftp server example, a network vulnerability scanner might:
1. Detect that a user can authenticate as _annonymous_
2. Once authenticated, test if the logged in user can change directories, access some common directory (i.e., /tmp or /etc or /), or attempt to change directories to a parent directory. A vulnerability scanner might report the ftp server vulnerable to [CVE-1999-0497](https://cve.mitre.org/cgi-bin/cvename.cgi?name=1999-0497). 

### HTTP vulnerability scanning tools
No tool is guaranteed to detect every vulnerability, and no tool is guaranteed to not report false positives. Therefore, one approach to improve the chances of detecting all existing vulnerabilities (averting false negatives) is to use more than one vulnerability scanner. Reported vulnerabilities require manual verification of each detected vulnerability.

Kali includes a suite of vulnerability scanning tools, including tools that specifically scan web applications for vulnerabilities. As we dig into these tools, remember that web vulnerability scanning tools will attempt to discover vulnerabilities in both the web server (i.e., Apache2, nginx, IIS, etc) and the application itself. The following section cover several tools:
1. **nikto** - An open source vulnerability scanner included with Kali. Nikto can scan for 6400 potential vulnerabilities. Nikto is not stealthy and can easily be detected. Therefore, it is useful for testing a website under the tester's control, but not the best choice for something such as a penetration test where stealth is important.
2. **legion** - Legion is GUI-based vulnerability scanner that replaced the longtime favorite **Sparta**. To be fair, Legion is broader in scope than a dedicated web application vulnerability scanner. Sparta was written in Python 2.7. Legion migrates Sparta to Python 3.6. Legion incorporates other security scanning tools, such as nmap, webslayer, SMBenum, hydra, and dozens of auto-scheduled scripts to detect Common Vulnerabilities (CVEs) and Common Platform Enumeration (CPEs). If legion is not installed in your Kali machine, you can install it with:
```
sudo apt update && sudo apt install legion
```

3. **skipfish** - Another free and open source web application security tool that is included with Kali. Skipfish is an active web application security tool that writes the results to an html file that can be viewed with a browser.
4. **wapiti** - A web application audit tool similar to skipfish. And, similar to skipfish, the results can be written to html and viewed with a browser.

## Operating select vulnerability scanning tools
**Ensure Docker image tleemcjr/metasploitable2 is started and Apache2 on the container is bound to TCP 9000 on the host.** Note: the web applications in Metasploitable2 are intentionally vulnerable. You can anticipate a very extensive list of discovered vulnerabilities. For the following examples, let's assume our Metasploitable2 is at IP address 150.1.1.1.

### Challenge 1: nikto
Scan Metasploitable2 web server using the default nikto scan.


```
nikto -host http://150.1.1.1:9000

- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          104.198.70.155
+ Target Hostname:    104.198.70.155
+ Target Port:        9000
+ Start Time:         2022-09-07 20:18:14 (GMT-6)
---------------------------------------------------------------------------
+ Server: Apache/2.2.8 (Ubuntu) DAV/2
+ Retrieved x-powered-by header: PHP/5.2.4-2ubuntu5.10
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ Server may leak inodes via ETags, header found with file /robots.txt, inode: 620222, size: 134, mtime: Tue Sep  6 10:30:15 2022
+ "robots.txt" contains 3 entries which should be manually viewed.

----- TRUNCATED -----

+ OSVDB-3092: /phpMyAdmin/README: phpMyAdmin is for managing MySQL databases, and should be protected or limited to authorized hosts.
+ 8732 requests: 0 error(s) and 28 item(s) reported on remote host
+ End Time:           2022-09-07 20:37:34 (GMT-6) (1160 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```
Note that many of the detected vulnerabilities reference OSVDB. OSVDB is short for Open Source Vulnerability Database. OSVDB was shut down in 2016. **Some** vulnerabilities reported in OSVDB may be found in other vulnerability databases. Mitre runs the National Vulnerability Database (NVD) and provides a [reference map](https://cve.mitre.org/data/refs/refmap/source-OSVDB.html) between OSVDB vulnerabilities and CVEs in the NVD.

Vulnerabilities are reported with the /test/ directory.

**Report:**

1. **The vulnerabilities reported with the /test/ directory.**
2. **Search the [reference map](https://cve.mitre.org/data/refs/refmap/source-OSVDB.html) for CVEs that map to the reported OSVDBs. Explain what you found.**
3. **Manually examine the directory /test/ and report your findings.**

### Challenge 2: legion
Start legion by running the command **legion**. 
1. Select the **Hosts** tab and click in the Hosts field. 
2. Add the IP address for your GCP instance. 
3. All other settings under hosts can be left as the default settings, or you can try different configurations. 
4. Click **submit**.

Legion will immediately start scanning the target. Results will be reported accross several tabs. Results can be observed in real-time as the legion continues the vulnerability scan.
1. Select the **services** tab. Several services will be discovered. Select the discovered services and observe the ports and service versions that were detected for each service.
2. Select the **tools** tab. Observe the results. The **screenshooter** tool will often produce results. Note the screenshooter results for each port.
3. Return to **hosts** and select the **CVEs** tab. Scroll to the ExploitDB ID column. Note that most entries say _unknown_. However, there are exceptions. Scroll down and find entries that are exceptions to _unknown_. 

**Record three of the reported Exploitdb IDs.**

Vulnerabilities with Exploitdb IDs are particularly noteworthy. A vulnerability is a weakness that could be exploited. However, not all vulnerabilities have exploits, but the vulnerabilities with an Exploitdb ID do have public exploits. The fact that a public exploit exists for a documented and discovered vulnerability increases the risk associated with that vulnerability.

1. Go to [exploit-db.com](https://www.exploit-db.com/).
2. Modify the URL to browse to the selected Exploit IDs (EDB-ID). For example, EDB-ID 1500 is found at www.exploit-db.com/exploits/1500.
3. Complete Table 1, Exploit-DB Results, for the three selected exploits.

|Item|Exploitdb-ID|_ _ _ _ _ _ Title _ _ _ _ _ _|_ _ CVE(s) _ _|
|:-:|---|---|---|
|1||||
|2||||
|3||||

Table 1, Exploit-DB Results

### Challenge 3: skipfish
Skipfish supports numerous options, such as user authentication, crawl scope, reporting options, dictionary management, and performance settings. The full list of options can be viewed with help menu (**skipfish -h**). You should review these options. However, the following example runs a default skipfish scan against the localhost. 

```
skipfish -o /tmp/skipfish_results http://localhost

skipfish version 2.10b by lcamtuf@google.com
- 104.198.70.155 - 

Scan statistics:

Scan time : 0:11:09.444
HTTP requests : 24954 (37.4/s), 59708 kB in, 10476 kB out (104.8 kB/s)
Compression : 1320 kB in, 4780 kB out (56.7% gain)
HTTP faults : 0 net errors, 0 proto errors, 0 retried, 0 drops
TCP handshakes : 264 total (96.6 req/conn)
TCP faults : 0 failures, 0 timeouts, 3 purged
External links : 1360 skipped
Reqs pending : 561

Database statistics:  
Pivots: 184 total, 82 done (44.57%)
In progress : 84 pending, 14 init, 3 attacks, 1 dict
Missing nodes : 14 spotted
Node types : 2 serv, 24 dir, 4 file, 60 pinfo, 45 unkn, 50 par, 0 val
Issues found : 105 info, 0 warn, 19 low, 128 medium, 1 high impact
Dict size : 128 words (128 new), 11 extensions, 256 candidates
Signatures : 77 total   
```

Complete a skipfish scan against Metasploitable2. **Browse to the results homepage and capture a screenshot of the results homepage.** The scan will take time to complete (probably more than an hour). You can open another terminal tab (**CTRL+SHIFT+T**) and proceed to the next challenge while the skipfish scan continues to run.

**Summarize the high impact Issues found.**

### Challenge 4: wapiti

Wapiti takes a different approach to vulnerability scanning. Wapiti does not directly attempt to identify known vulnerabilities but scans applications for points where data can be injected. Once found, wapiti fuzzes inputs to discover common vulnerability types such as cross-site scripting, database injection, file disclosure. The following example runs a default wapiti scan against the localhost, but with verbosity.
```
wapiti -v 1 -u http://localhost


     __      __               .__  __  .__________
    /  \    /  \_____  ______ |__|/  |_|__\_____  \
    \   \/\/   /\__  \ \____ \|  \   __\  | _(__  <
     \        /  / __ \|  |_> >  ||  | |  |/       \
      \__/\  /  (____  /   __/|__||__| |__/______  /
           \/        \/|__|                      \/
Wapiti-3.0.4 (wapiti.sourceforge.io)
[*] You are lucky! Full moon tonight.
[*] Resuming scan from previous session, please wait
[+] GET http://localhost/ (0)
```
Complete a wapiti scan against Metasploitable2. Again, this scan will take time to complete. Let it run. Progress can be monitored by using a verbosity option in the scan.
