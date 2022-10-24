# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Introduction to Structured Query Language (SQL) for SQL injection (SQLi)

## Deploy a SQLi Lab

### Challenge 1: Clone a GitHub Repository
GitHub is a cloud-based service for developers to store and manage code, track changes, and to share code. Exercise and lab instructions for this course are shared through GitHub. This exercise uses code from another GitHub repository to deploy a Docker-based SQLi testing envrironment. The first step to build the testing environment is to **clone** the repository. Cloning simply means to copy a GitHub repository to another machine.

Figure 1 shows the [GitHub thomaslaurenson/startrek_payroll repository](https://github.com/thomaslaurenson/startrek_payroll) used in this exercise. Clicking the green Code button shows the URL used to clone the repository.

<img src="../images/github_repo.png" width="800" height="900">

**Figure 1, GitHub Repository**

The following commands install the prerequisite **git** package, clones the repository, and shows the content of the repository on a Linux host.
```
sudo apt update && sudo apt install git -y
git clone https://github.com/thomaslaurenson/startrek_payroll.git
cd startrek_payroll
```
**Clone the thomaslaurenson/startrek_payroll repository and capture a screenshot of the contents of the repository.**

### Challenge 2: All that Stuff in this Repo!
GitHub content is normally safe, but GitHub repositories could also be used to distribute malicious or harmful content. It is a good practice to examine content in a repository you do not own or control before running scripts or deploying applications, so let's look at what is in the repository.

```
~/startrek_payroll$ ls -l
total 40
-rw-rw-r-- 1 kbarton kbarton 1524 Oct 24 15:21 LICENSE
-rw-rw-r-- 1 kbarton kbarton  911 Oct 24 15:21 README.md
drwxrwxr-x 2 kbarton kbarton 4096 Oct 24 15:21 app
-rwxrwxr-x 1 kbarton kbarton 1119 Oct 24 15:21 clean.sh
-rw-rw-r-- 1 kbarton kbarton 2051 Oct 24 15:23 docker-compose.yml
-rwxrwxr-x 1 kbarton kbarton  987 Oct 24 15:21 launch.sh
drwxrwxr-x 2 kbarton kbarton 4096 Oct 24 15:21 mysql
drwxrwxr-x 2 kbarton kbarton 4096 Oct 24 15:21 nginx
drwxrwxr-x 2 kbarton kbarton 4096 Oct 24 15:21 php
-rwxrwxr-x 1 kbarton kbarton  984 Oct 24 15:21 run.sh
```
The repository contains a license, README, three bash scripts (clean.sh, launch.sh, and run.sh), a docker-compose.yml, and four directories (app, mysql, nginx, and php).

**LICENSE** is a standard open source BSD license. The contents are simple text and authorize the use or modification of the repository content without restrictions.  

**README.md** summarizes the project and provides instructions to use the project. Note that README.md states the vulnerable web application will be found on TCP 8080. We will modify docker-compose.yml to deploy the application on another port.

The first two bash scripts **launch.sh** and **run.sh** are similar. Both scripts contain a statement that the content can be used and modified under the terms of the GNU General Public License (GNU GPL). 

The script run.sh has one command, **docker-compose up --build**. The script launch.sh has a similar command, **docker-compose up**. The first script is used to build the images while the second script is used to start the containers. In practice, launch.sh would build the images and start the containers without having to run the command in run.sh. We will not use either of these scripts. Instead, we will deploy the containers by running **sudo docker-compose up -d**.

The last script, clean.sh stops the containers, removes associated volumes and containers, and removes the images.

The three scripts are safe, so examine **docker-compose.yml**. Again, we find a statement that the content is licensed for use and modification under GNU GPL. In addition, there is a complete docker-compose configuration. Let's examine this.

```
version: '3'
services:
  mysql:
    image: mysql:5.5
    container_name: startrek_payroll_mysql
    restart: unless-stopped
    environment:
      - MYSQL_HOST=localhost
      - MYSQL_ROOT_PASSWORD=sploitme
      - MYSQL_DATABASE=payroll
      - MYSQL_PORT=3306
    volumes:
      - ./mysql/startrek_payroll.sql:/docker-entrypoint-initdb.d/startrek_payroll.sql
    networks:
      - backend

  php:
    image: php:8.0-fpm
    container_name: startrek_payroll_php
    restart: unless-stopped
    build:
      context: php
      dockerfile: Dockerfile
    depends_on:
      - mysql
    volumes:
      - ./app:/app
    networks:
      - backend

  nginx:
    image: nginx:stable-alpine
    container_name: startrek_payroll_nginx
    restart: unless-stopped
    depends_on:
      - mysql
      - php
    ports:
      - "8080:80"
    volumes:
      - ./app:/app
      - ./nginx/site.conf:/etc/nginx/conf.d/default.conf
    networks:
      - frontend
      - backend

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
```
The project will deploy three separate containers: a MySQL database service, nginx web server, and a PHP service.The nginx service is dependent on both the mysql and php services. Names for all three containers are specified in the .yml file, and could be modified if you desired. 

Each container is also bound to a local volume. Assigning a volume makes the container's data more persistent and easier to backup. Assigning a volume connects a container's internal directory to an external directory on the host. In this project, internal directories are being connected to directories in the repository: app, mysql, and nginx. The content of app, mysql and nginx will be the deployed application. 

Two network are created. The network names are **frontend** and **backend**. The services mysql and php are connected to backend and nginx is connected to both backend and frontend.

Environment variables are set for mysql, to include the root user's password and the database name payroll. The database payroll will be populated with the content from /mysql/startreck_payroll.sql. 

Directory php/ contains a Dockerfile. Dockerfile is used to build the php service in docker-compose.yml.

Before we deploy the lab, **modify docker-compose.yml to change the published port on nginx from 8080 to 8502**. Save the modified docker-compose.yml and start the project with the command:

```
~/startrek_payroll$ sudo docker-compose up -d

Status: Downloaded newer image for nginx:stable-alpine
Creating startrek_payroll_mysql ... done
Creating startrek_payroll_php   ... done
Recreating startrek_payroll_nginx ... done
```
