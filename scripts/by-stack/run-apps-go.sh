
#!/bin/bash

#Start Catalogue microservice
./bin/catalogue -port=8084 &

#Start Payment microservice
./bin/payment -port=8085 &

#Start User microservice
./bin/user -port=8086

  
# Wait for any process to exit
#wait -n
  
# Exit with status of process that exited first
# exit $?