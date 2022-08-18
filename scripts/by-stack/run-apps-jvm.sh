
#!/bin/bash

#Start the Carts microservice
java -jar bin/carts.jar --port=8081 &
  
#Start the Orders microservice
java -jar bin/orders.jar --port=8082 &

#Start the Shipping microservice
java -jar bin/shipping.jar --port=8083

  
# Wait for any process to exit
#wait -n
  
# Exit with status of process that exited first
# exit $?