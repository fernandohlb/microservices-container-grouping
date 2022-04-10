
#!/bin/bash

#Start cart app


# Start the Carts microservice
java -jar bin/carts.jar --port=8081 &
  
# # Start the Orders microservice
java -jar bin/orders.jar --port=8082 &

# # # Start the Shipping microservice
java -jar bin/shipping.jar --port=8083 &

# # #Start Catalogue microservice
./bin/catalogue -port=8084 &

# # #Start Payment microservice
./bin/payment -port=8085 &

# #Start User microservice
./bin/user -port=8086
  
# Wait for any process to exit
#wait -n
  
# Exit with status of process that exited first
# exit $?