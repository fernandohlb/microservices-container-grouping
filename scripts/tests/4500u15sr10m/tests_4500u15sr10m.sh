INITIAL_DATE=$(date -u -d "-1 hour" +"%FT%H:00:01Z")
FINAL_DATE=$(date -u +"%FT%H:00:00Z")
echo "Get Cost Before Test - From $INITIAL_DATE to $FINAL_DATE"
kubectl cost namespace --show-all-resources --window $INITIAL_DATE,$FINAL_DATE > cost_result_before.csv

echo '########## Benchmark Test 100 user 01 spawn rate 10 minutes ##########'

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no benchmark/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/results.html benchmark
echo '########## Benchmark Test 100 user 01 spawn rate 10 minutes finished ##########'


echo '########## All-In-One Test 100 user 01 spawn rate 10 minutes ##########'

#scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no locustfile.py ec2-user@ec2-15-228-174-255.sa-east-1.compute.amazonaws.com:/tmp
scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no all-in-one/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/results.html all-in-one
echo '########## All-In-One Test 100 user 01 spawn rate 10 minutes finished ##########'

echo '########## By-Stack Test 100 user 01 spawn rate 10 minutes ##########'

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no by-stack/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/results.html by-stack
echo '########## By-Stack Test 01 user 100 spawn rate 10 minutes finished ##########'

echo '########## By-Dependencies Test 100 user 01 spawn rate 10 minutes ##########'

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no by-dependencies/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/results.html by-dependencies
echo '########## By-Dependencies Test 100 user 01 spawn rate 10 minutes finished ##########'

INITIAL_DATE=$(date -u +"%FT%H:00:01Z")
FINAL_DATE=$(date -u -d "+1 hour" +"%FT%H:00:00Z")
echo "Get Cost After Test - From $INITIAL_DATE to $FINAL_DATE"
kubectl cost namespace --show-all-resources --window $INITIAL_DATE,$FINAL_DATE > cost_result_after.csv
