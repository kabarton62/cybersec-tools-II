<img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="200" height="100"> 

# SQLi with sqlmap

## Deploy the Target

### Challenge 1: Download the Repository from GitHub

The application is packaged as a Docker container. Clone and download a copy of the application:

```
git clone https://github.com/kabarton62/sqliStore.git
```

### Challenge 2: Build the Docker Image

Change into the directory and build using docker. The image name will be store.

```
cd sqliStore
docker build -t store .
```

### Challenge 3: Run the Docker Application

To run it detached mode

```
docker run -itd --rm -p 8505:80 --name sqlistore store
```

This will make sqliStore available at http://localhost:8505 or http://[ip address]:8505

Do not expose sqliStore to the internet, it is an insecure application and can lead to a system or network compromise. 
Use it in an isolated test lab environment meant for security testing and learning. 
 
Note the mariadb database is restored each time the docker container is started up.     

### Challenge 4: Enumerate dbms, Current User and Current Database

Use sqlmap to enumerate the dbms, current user and current database. 

> :anger: Capture a screenshot that shows the dbms, current user and current database.

### Challenge 5: Enumerate Databases

Use sqlmap to enumerate the databases the current user can access.

> :anger: Capture a screenshot that shows the databases the current user can access.

### Challenge 6: Enumerate MySQL Users

Use sqlmap to enumerate MySQL users. Attempt to crack all passwords for discovered MySQL users.

> :anger: Capture a screenshot that shows the MySQL users and cracked passwords.


