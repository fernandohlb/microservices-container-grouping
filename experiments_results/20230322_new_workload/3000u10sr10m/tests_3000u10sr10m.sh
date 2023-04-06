# INITIAL_DATE=$(date -u -d "-1 hour" +"%FT%H:00:01Z")
# FINAL_DATE=$(date -u +"%FT%H:00:00Z")
# echo "Get Cost Before Test - From $INITIAL_DATE to $FINAL_DATE"
# kubectl cost namespace --show-all-resources --window $INITIAL_DATE,$FINAL_DATE > cost_result_before.csv

echo '########## Benchmark Test 3000 users 10 spawn rate 10 minutes ##########'

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no benchmark/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

# INITIAL_DATE_BEFORE=$(date -u -d "-11 minute" +"%FT%H:%M:%SZ")
# FINAL_DATE_BEFORE=$(date -u -d "-1 minute" +"%FT%H:%M:%SZ")
# echo 'Get costs before running - Initial Date: '$INITIAL_DATE_BEFORE ' | Final Date: '$FINAL_DATE_BEFORE
# echo $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > benchmark/time_before.txt
# kubectl cost pod -n benchmark --show-all-resources --window $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > benchmark/cost_before_benchmark.csv

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

#INITIAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

sleep 10.5m

# FINAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/results.html benchmark

# sleep 5m

# echo 'Get costs after running - Initial Date: '$INITIAL_DATE_AFTER ' | Final Date: '$FINAL_DATE_AFTER
# echo $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > benchmark/time_after.txt
# kubectl cost pod -n benchmark --show-all-resources --window $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > benchmark/cost_after_benchmark.csv

echo '########## Benchmark Test 3000 users 10 spawn rate 10 minutes finished ##########'

#######################################################################################################################################################################################################

echo '########## All-In-One Test 3000 users 10 spawn rate 10 minutes ##########'

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no all-in-one/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

# INITIAL_DATE_BEFORE=$(date -u -d "-11 minute" +"%FT%H:%M:%SZ")
# FINAL_DATE_BEFORE=$(date -u -d "-1 minute" +"%FT%H:%M:%SZ")
# echo 'Get costs before running - Initial Date: '$INITIAL_DATE_BEFORE ' | Final Date: '$FINAL_DATE_BEFORE
# echo $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > all-in-one/time_before.txt
# kubectl cost pod -n all-in-one --show-all-resources --window $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > all-in-one/cost_before_all-in-one.csv

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# INITIAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

sleep 10.5m

# FINAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/results.html all-in-one

# sleep 5m

# echo 'Get costs after running - Initial Date: '$INITIAL_DATE_AFTER ' | Final Date: '$FINAL_DATE_AFTER
# echo $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > all-in-one/time_after.txt
# kubectl cost pod -n all-in-one --show-all-resources --window $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > all-in-one/cost_after_all-in-one.csv

echo '########## All-In-One Test 3000 users 10 spawn rate 10 minutes finished ##########'

#######################################################################################################################################################################################################

echo '########## By-Stack Test 3000 users 10 spawn rate 10 minutes ##########'

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no by-stack/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

# INITIAL_DATE_BEFORE=$(date -u -d "-11 minute" +"%FT%H:%M:%SZ")
# FINAL_DATE_BEFORE=$(date -u -d "-1 minute" +"%FT%H:%M:%SZ")
# echo 'Get costs before running - Initial Date: '$INITIAL_DATE_BEFORE ' | Final Date: '$FINAL_DATE_BEFORE
# echo $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > by-stack/time_before.txt
# kubectl cost pod -n by-stack --show-all-resources --window $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > by-stack/cost_before_by-stack.csv

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# INITIAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

sleep 10.5m

# FINAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/results.html by-stack

# sleep 5m

# echo 'Get costs after running - Initial Date: '$INITIAL_DATE_AFTER ' | Final Date: '$FINAL_DATE_AFTER
# echo $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > by-stack/time_after.txt
# kubectl cost pod -n by-stack --show-all-resources --window $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > by-stack/cost_after_by-stack.csv

echo '########## By-Stack Test 3000 users 10 spawn rate 10 minutes finished ##########'

#######################################################################################################################################################################################################

echo '########## By-Dependencies Test 3000 users 10 spawn rate 10 minutes ##########'

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no by-dependencies/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

# INITIAL_DATE_BEFORE=$(date -u -d "-11 minute" +"%FT%H:%M:%SZ")
# FINAL_DATE_BEFORE=$(date -u -d "-1 minute" +"%FT%H:%M:%SZ")
# echo 'Get costs before running - Initial Date: '$INITIAL_DATE_BEFORE ' | Final Date: '$FINAL_DATE_BEFORE
# echo $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > by-dependencies/time_before.txt
# kubectl cost pod -n by-dependencies --show-all-resources --window $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > by-dependencies/cost_before_by-dependencies.csv


echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# INITIAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

sleep 10.5m

# FINAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/results.html by-dependencies

# sleep 5m

# echo 'Get costs after running - Initial Date: '$INITIAL_DATE_AFTER ' | Final Date: '$FINAL_DATE_AFTER
# echo $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > by-dependencies/time_after.txt
# kubectl cost pod -n by-dependencies --show-all-resources --window $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > by-dependencies/cost_after_by-dependencies.csv

echo '########## By-Dependencies Test 3000 users 10 spawn rate 10 minutes finished ##########'

# INITIAL_DATE=$(date -u +"%FT%H:00:01Z")
# FINAL_DATE=$(date -u -d "+1 hour" +"%FT%H:00:00Z")
# echo "Get Cost After Test - From $INITIAL_DATE to $FINAL_DATE"
# kubectl cost namespace --show-all-resources --window $INITIAL_DATE,$FINAL_DATE > cost_result_after.csv
