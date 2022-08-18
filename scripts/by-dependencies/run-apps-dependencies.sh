
#!/bin/bash

  
#Start the Orders microservice
java -jar bin/orders.jar --port=8082 &

#Start the Shipping microservice
java -jar bin/shipping.jar --port=8083 &

#Start Payment microservice
./bin/payment -port=8085