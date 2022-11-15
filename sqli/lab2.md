<img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="200" height="100"> 

# SQLi with sqlmap

## Deploy the Target

The application is packaged as a Docker application. Clone and download a copy for the application

    git clone https://github.com/kabarton62/sqliStore.git

Change into the directory and build using docker

    cd sqliStore
    docker build -t store .

## Running the Docker Application

To run it detached mode

    docker run -itd --rm -p 8505:80 store

This will make sqliStore available at http://localhost:8505 or http://[ip address]:8505

Do not expose sqliStore to the internet, it is an insecure application and can lead to a system or network compromise. 
Use it in an isolated test lab environment meant for security testing and learning. 
 
Note the mariadb database is restored each time the docker container is started up.     
