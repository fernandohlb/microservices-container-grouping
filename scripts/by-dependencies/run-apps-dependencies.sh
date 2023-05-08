
#!/bin/bash

  
#Start the Orders microservice
java -Xms64m -Xmx256m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom -Dspring.zipkin.enabled=false -Dhttp.timeout=15 -jar bin/orders.jar --port=8082 &

#Start the Shipping microservice
java -Xms64m -Xmx128m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom -Dspring.zipkin.enabled=false -jar bin/shipping.jar --port=8083 &

#Start Payment microservice
./bin/payment -port=8085