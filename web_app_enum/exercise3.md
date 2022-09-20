# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Application Enumeration - Vulnerability Scans

## Web application user enumeration and password attacks
This exercise introduces two additional tools for web application vulnerability testing: **wpscan** and **wfuzz**. 

Wpscan is a dedicated WordPress vulnerability scanner capable of detecting known vulnerabilities in the WordPress core and in WordPress plugins. Security in the ordPress core has been improved significantly over the years. Modern releases are well patched and well-known vulnerabilities have been effictively remediated. WordPress plugins are a different story. WordPress plugins are created by third-party developers. Most vulnerabilities in modern WordPress deployments are found in plugins, not the WordPress core. Wpscan tests both the core and plugins for known vulnerabilies.

Wfuzz is an http/https fuzzing tool that can be used for directory or resource enumeration and web application password attacks. This exercises focuses on web application password attacks using wfuzz.

## Building the lab
The target web applications will be build using Docker containers. The Docker containers and their networking configurations will be deployed using docker-compose. Docker-compose may not be installed on your server, so the first step is to install docker-compose.

```
sudo apt update &&  sudo apt install docker-compose -y
```

Configuration for Docker containers created with docker-compose are established in a .yml file. Although the .yml filename can be custom, the default filename for docker-compose configuration files is **docker-compose.yml**. We will use the default filename. Prepare your Ubuntu server:
1. Create a directory named **wordpress/**
2. In wordpress/ create the file **docker-compose.yml** and add the following:

```
version: '2'
services:
 web:
   container_name: wordpress
   image: vulhub/wordpress:4.6
   depends_on:
    - mysql
   environment:
    - WORDPRESS_DB_HOST=mysql:3306
    - WORDPRESS_DB_USER=root
    - WORDPRESS_DB_PASSWORD=root
    - WORDPRESS_DB_NAME=wordpress
   ports:
    - "10000:80"
   networks:
     wpbr:
       ipv4_address: 172.19.0.3
 mysql:
   container_name: mysql
   image: mysql:5
   environment:
    - MYSQL_ROOT_PASSWORD=root
   networks:
     wpbr:
       ipv4_address: 172.19.0.4

networks:
  wpbr:
    driver: bridge
    ipam:
     config:
       - subnet: 172.19.0.0/24
         gateway: 172.19.0.1
```
