#!/bin/bash

echo "***** Welcome, this script will enable a nginx web server to publish the website Settle. *****"
echo ""
echo "Image architecture: linux/amd64 Do you want to continue? y/n:"
read continue
if [ $continue == 'n' ]
   then 
      exit 0
fi

while [ $continue != 'y' ]
      do 
	echo "Invalid option, please write y or n:"
        read continue
        if [ $continue == 'n' ]
           then
             exit 0
        fi
      done

echo ""
echo "Please make sure that port 8080 is not allocated in the host."
echo ""
echo "=== Setting up network ==="
docker network create settle-app
echo ""
echo "Network name: settle-app running..."
echo ""
echo "=== Setting up MariaDB instance ==="
docker container run \
-dp 3306:3306 \
--name settle-db \
--env MARIADB_USER=maria-user \
--env MARIADB_PASSWORD=maria-pass \
--env MARIADB_ROOT_PASSWORD=root-user-password \
--env MARIADB_DATABASE=settle-db \
--volume settle-db:/var/lib/mysql \
--network settle-app \
mariadb:jammy
echo "SQL database ready"
echo
echo "=== Setting up PHPMyAdmin instance ==="
docker container run \
--name phpmyadmin \
-d \
-e PMA_ARBITRARY=1 \
-p 8081:80 \
--network settle-app \
phpmyadmin:5.2.0-apache
echo "PHPMyAdmin ready at http://localhost:8081"
echo ""
echo "*****************************************"
echo "******** Server: settle-db    ***********"
echo "******** Username: maria-user ***********"
echo "******** Password: maria-pass ***********"
echo "*****************************************"
echo ""
echo "***** yeah, I know this is insecure... it is just for you guys to test. *****"
echo ""
echo "=== Setting up nginx web server ==="
docker container run \
--name nginx-settle \
-dp 8080:80 \
--network settle-app \
tuahil/settle-alpine
echo "Web server running..."
echo ""
echo "== Testing connection between web server and mariadb =="
echo "***** TO STOP TESTING CONNECTION PRESS: Ctrl-C"
echo ""
docker exec -ti nginx-settle ping settle-db
echo ""
echo "To explore website plase visit http://localhost:8080"
echo ""
echo "To stop services and cleaning up press 's':"
read terminate
while [ $terminate != 's' ]
      do 
       echo "To stop service and cleaning up press 's':"
       read terminate
      done
docker container rm -f settle-db phpmyadmin nginx-settle
docker network rm -f settle-app
docker volume rm settle-db
echo "To eliminate images and volumes from your system press 'p' or 'Ctrl_C' to exit:"
read prn
while [ $prn != 'p' ]
      do 
       echo "To eliminate images and volumes press 'p' or 'Ctrl-C' to exit':"
       read prn
      done

if [ $prn == 'p' ]
   then
      docker system prune -a
      echo "***** Bye... *****"
fi

