
#!/bin/bash

#Start the Carts microservice
java -Xms64m -Xmx128m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom -Dspring.zipkin.enabled=false -jar bin/carts.jar --port=8081 &
  
#Start the Orders microservice
java -Xms64m -Xmx256m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom -Dspring.zipkin.enabled=false -jar bin/orders.jar --port=8082 &

#Start the Shipping microservice
java -Xms64m -Xmx128m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom -Dspring.zipkin.enabled=false -jar bin/shipping.jar --port=8083 &

#Start Catalogue microservice
./bin/catalogue -port=8084 &

#Start Payment microservice
./bin/payment -port=8085 &

#Start User microservice
./bin/user -port=8086 &

#Start the Shipping microservice
java -Xms64m -Xmx128m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom -Dspring.zipkin.enabled=false -jar bin/queue-master.jar --port=8087 &


#Start FrontEnd Microservice
npm start --prefix bin/front-end

  
# Wait for any process to exit
#wait -n
  
# Exit with status of process that exited first
# exit $?