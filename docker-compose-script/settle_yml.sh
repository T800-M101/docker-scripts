#!/bin/bash

echo "***** Welcome, this script will enable a nginx web server to publish the website Settle using docker compose file. *****"
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
docker compose up -d
echo ""
echo "Network name: settle-app running..."
echo ""
echo "=== Setting up MariaDB instance ==="
echo ""
echo "SQL database ready"
echo
echo "=== Setting up PHPMyAdmin instance ==="
echo ""
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
echo ""
echo "Web server running..."
echo ""
echo "== Testing connection between web server and mariadb =="
echo ""
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
docker compose down
echo "To eliminate images and volumes from your system press 'p' or 'Ctrl-C' to exit:"
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
