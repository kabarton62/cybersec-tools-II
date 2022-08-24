# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Application Enumeration - Vulnerability Scans

## Web application vulnerability scanning
The National Institute of Standards and Technology (NIST) defines [vulnerability](https://csrc.nist.gov/glossary/term/vulnerability) as a "weakness in a system, system security procedures, internal controls, or implementation that could be exploited or triggered by a threat." A vulnerability could be a weakness such as a software bug, failure to properly implement a control or countermeasure used to remediate some weakness, a workflow weakness, a weak configuration, or other weaknesses. There is a common tendency to recognize software flaws as sources of vulnerabilities, but to not consider other sources such as configuration errors. While developers generally provide patches to fix software vulnerabilites, there is no such equivalent to **patching** for configuration errors. So, let's take a deeper look at the idea of configuration errors.

### Configuration errors
A **configuration error** is a condition, setting or parameter that creates a vulnerability or interrupts system operation. We are concerned with configuration errors that create vulnerabilities. Consider the following example to better understand configuration errors and their relationship to vulnerabilities.

File Transfer Protocol (ftp) is used to transfer files between an ftp server and ftp client. 
