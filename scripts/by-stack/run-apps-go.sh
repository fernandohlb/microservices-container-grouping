
#!/bin/bash

#Start Catalogue microservice
./bin/catalogue -port=8084 &

#Start Payment microservice
./bin/payment -port=8085 &

#Start User microservice
./bin/user -port=8086