# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> cybersec-tools-II


---
## Part 1, Web Applications: [web_application](https://github.com/kabarton62/cybersec-tools-II/tree/main/web_application)

### [Exercise 1-1](https://github.com/kabarton62/cybersec-tools-II/blob/main/web_application/exercise.md) 
The exercise introduces students web application components and provides a tutorial to create a LAMP server install WordPress. Instructions assume the student does not have prior knowledge deploying a PHP-based web application. 

### [Lab 1](https://github.com/kabarton62/cybersec-tools-II/blob/main/web_application/lab.md) 
The lab extends the skills practiced in exercise.md to deploy Ticket-Booking 1.4 and dependencies (Apache2, PHP and MySQL).

## Part 2, Web Application Enumeration: [web_app_enum](https://github.com/kabarton62/cybersec-tools-II/tree/main/web_app_enum)

### [Exercise 2-1](https://github.com/kabarton62/cybersec-tools-II/blob/main/web_app_enum/exercise1.md)
Exercise 1 introduces students to HTTP responses, basic web application organization on a web server and resource enumeration. Includes a lab using a Metasploitable2 Docker container. Students deploy the lab target and complete web server enumeration using basic techniques such as robots.txt and forced browsing with multiple tools.

### [Exercise 2-2](https://github.com/kabarton62/cybersec-tools-II/blob/main/web_app_enum/exercise2.md)
Exercise 2 introduces web server and web application vulnerability scanning using nikto, legion (sparta ported to Python3), skipfish and wapiti.

### [Exercise 2-3](https://github.com/kabarton62/cybersec-tools-II/blob/main/web_app_enum/exercise3.md)
Exercise 3 introduces web application user enumeration and password attacks. Students deploy a lab network using docker-compose. The lab network includes WordPress. Students modify the WordPress container to add a second PHP-based web application. User enumeration and a password attack is conducted on the WordPress application using WPScan. A password attack is executed against the second web application using wfuzz.

### Labs
Students complete black-box testing against instructor developed and deployed targets. Contact the repository owner for lab samples.

## Part 3, Burp Suite: [burpsuite](https://github.com/kabarton62/cybersec-tools-II/tree/main/burpsuite)

### [Exercise 3-1](https://github.com/kabarton62/cybersec-tools-II/blob/main/burpsuite/exercise1.md)
Exercise 1 walks students through Burp Suite configuration. Students are introduced to target and scope configuration.

### [Exercise 3-2](https://github.com/kabarton62/cybersec-tools-II/blob/main/burpsuite/exercise2.md)
Exercise 2 introduces the Repeater and Intruder tools. These tools are used to complete a Local File Inclusion (LFI) attack againsta a Metasploitable2 container.

### [Exercise 3-3](https://github.com/kabarton62/cybersec-tools-II/blob/main/burpsuite/exercise3.md)
Exercise 3 introduces the Decoder and Comparer tools. Students [deploy an Ubuntu web server using a bash script](https://github.com/kabarton62/cybersec-tools-II/blob/main/burpsuite/exercise3-deploy.sh). The exercise explains the bash script function. The web server includes configurations that require the use of Burp Suite Decoder tools. The Comparer tool is also introduced. 
