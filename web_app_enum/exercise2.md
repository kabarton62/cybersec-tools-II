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
