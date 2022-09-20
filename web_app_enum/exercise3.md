# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Web Application Enumeration - Vulnerability Scans

## Web application user enumeration and password attacks



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
