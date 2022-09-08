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

3. **skipfish** - Another free and open source web application security tool that is included with Kali. Skipfish writes the results to an html file that can be viewed with a browser.
4. **wapiti** - A web application audit tool similar to skipfish. And, similar to skipfish, the results can be written to html and viewed with a browser.

## Operating select vulnerability scanning tools

