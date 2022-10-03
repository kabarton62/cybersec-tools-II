# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Burp Suite - Getting Started

## Attacking DVWA with Burp Suite
Ensure Metasploitable2 is running on your GCP instance. Start the Metasploitable2 Docker container using the following:

```
sudo docker run -p 2222:22 -p 20:20 -p 21:21 -p 2323:23 -p 25:25 -p 514:514 -p 2049:2049 -p 3632:3632 -p 9000:80 \
--name metasploitable2 --hostname metasploitable2 -it -d tleemcjr/metasploitable2:latest sh -c "/bin/services.sh && bash"
```

### Challenge 1: Start and configure Burp Suite to capture DVWA requests
In the prior exercise, you learned how to configure Burp Suite to capture traffic to a web application while minimizing noise from unwanted traffic. Tasks included:
1. Configuring a browser to proxy through Burp Suite.
2. Restricting the **Target** and **Scope**.
3. Using **Repeater** to modify HTTP request.

**Configure the browser and Burp Suite to capture traffic to DVWA on Metasploitable2. Browse to the DVWA Login page.**

**Capture a screenshot of the HTTP GET request and response in Burp Suite.**

## Using Burp Suite's Intercept tool
In the previous exercise we used the **Repeater** tool edit HTTP requests. Although the Repeater tool allows us to edit requests, the response is not returned to the browser. **Intercept** is similar to Repeater but will return responses to the browser. Intercept catches the requests and holds it until the user forwards the request. The user can modify the request prior to forwarding the request.

#### Challenge 2: Use Intercept to capture and modify an HTTP request
Ensure that **Intercept** is turned on.
1. Select **Proxy** > **Intercept**
2. Ensure the **Intercept is on/off** button is set to **Intercept is on**.
3. Stay on the **Proxy** > **Intercept** tab.

Browse to the DVWA web application. Note that the page will not load in the browser and that the Intercept tab is holding the HTTP GET request to /dvwa/login.php. 

Click **Forward** in the Intercept tab. The DVWA page should load. Some web applications will have multiple requests before the page fully loads. Each request will be captured in Burp and must be manually forwarded.

The correct username and password for DVWA is admin/password (see the small print on DVWA's login page). However, we are going to enter the wrong credentials in the login page and then modify them using Intercept. Enter the following credentials:
```
Username: mickey
Password: mouse
```
Click **login**. 

Inspect **Intercept** and observe the POST request. **Capture a screenshot of the POST request with the username/password of mickey/mouse.**

Modify the username and password to the correct username/password (admin/password) and **capture a screenshot of the modified request**. click **Forward**.

## Using Burp Suite's Repeater tool
### Challenge 3: Use Repeater to attack a local file inclusion (LFI) vulnerability
1. In Burp Suite, turn **Intercept** off. 
2. In DVWA, select **DVWA Security**, set the security level to **low** and click **Submit**.
3. In DVWA, select the **File Inclusion** button.
4. Return to Burp Suite. Examine the HTTP GET request to /dvwa/vulnerabilities/fi/?page=include.php. The DVWA page that loads refers to the **?page=** parameter and suggests that a file can be _included_ by tampering with that paramter. Let's give it a try.

Send the HTTP GET request to the Repeater tool and tamper with the request.
1. Right-click the HTTP GET request.
2. Select the **Repeater** tool tab.
3. Change the file include.php in line 1 (GET /dvwa/vulnerabilities/fi/?page=include.php HTTP/1.1) to index.php.
4. Click **Send** and examine the response. Note that it seems the index.php file attempted to load but resulted in a memory error.

Now, let's try to find a more interesting file, such as a system file. When testing for LFI vulnerabilites it makes sense to search for files that are expected to exist and that all users have read permissions to, such as /etc/hosts, /etc/hostname or /etc/passwd on a Linux system. Start with /etc/passwd.

Attempt to read /etc/passwd using the LFI vulnerability and Burp Suite's Repeater tool. **Capture a screenshot of the HTTP request and response in Burp Suite.**

## Using Burp Suite's Intruder tool
### Challenge 4: Use Intruder to attack a LFI vulnerability 
We can use this vulnerability to enumerate the number of directories from the current directory (the directory that contains include.php) to the root directory (/). Although we could do the same task manually we will instead use the automated **Intruder** tool to complete the attack.

1. Forward the last HTTP request from Repeater to Intruder.
2. Go to the Intruder tool tab. You should be directed to the **Positions** tab in Intruder.
3. Note the highlighted items bound by "§". These are the fields that would be tampered with in an automated attack using Intruder. However, we do not want to tamper with the two cookies _security_ or _PHPSESSID_. These two fields need to be deselected.
4. Click **Clear §**. Ensure the three items are deselected.
5. Highlight the filename following _?page=_. See the following example.

```
GET /dvwa/vulnerabilities/fi/?page=§/etc/passwd§ HTTP/1.1
Host: 104.198.70.155:9000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101 Firefox/104.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: close
Cookie: security=low; PHPSESSID=edbd66175346dd39eb372485a8f6a8cc
Upgrade-Insecure-Requests: 1
```
6. Next, prepare the _payload_. The payload is the content that will be injected into the _positions_. Select the **Payloads** tab.
7. The default settings should be:
|||
|---|---|
|**Payload set:**| 1 |
|**Payload type:**|Simple list|

8. Paste the following list in **Payload Options [Simple list]**
```
../etc/passwd
../../etc/passwd
../../../etc/passwd
../../../../etc/passwd
../../../../../etc/passwd
../../../../../../etc/passwd
../../../../../../../etc/passwd
../../../../../../../../etc/passwd
```
