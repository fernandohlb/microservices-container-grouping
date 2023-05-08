FOLDER_DATE=$(date +"%Y%m%d")
WORKLOAD_USERS=300
SPAWN_RATE=01

#declare -a arr=("benchmark" "all-in-one" "by-stack" "by-dependencies")

for i in "benchmark" "all-in-one" "by-stack" "by-dependencies"
do 
    echo '##########' $i 'Test '$WORKLOAD_USERS' users' $SPAWN_RATE' spawn rate 10 minutes ##########'
    scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no $i/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp
    echo 'Run Locust workload'
    kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/
    sleep 10.5m
    kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

    scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.html $i
    scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.csv $i

    mkdir -p ../../../experiments_results/$FOLDER_DATE

    mkdir -p ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS
    mkdir -p ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/$i
    cp $i/*.html ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/$i
    cp $i/*.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/$i   
    echo '########## '$i' Test' $WORKLOAD_USERS 'users' $SPAWN_RATE' spawn rate 10 minutes finished ##########'
 
    ssh -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com "rm -rf /tmp/*.csv"
done




# echo '########## Benchmark Test 300 users 01 spawn rate 10 minutes ##########'

# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no benchmark/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

# # INITIAL_DATE_BEFORE=$(date -u -d "-11 minute" +"%FT%H:%M:%SZ")
# # FINAL_DATE_BEFORE=$(date -u -d "-1 minute" +"%FT%H:%M:%SZ")
# # echo 'Get costs before running - Initial Date: '$INITIAL_DATE_BEFORE ' | Final Date: '$FINAL_DATE_BEFORE
# # echo $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > benchmark/time_before.txt
# # kubectl cost pod -n benchmark --show-all-resources --window $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > benchmark/cost_before_benchmark.csv

# echo 'Run Locust workload'
# kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# #INITIAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

# sleep 10.5m

# # FINAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

# kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.html benchmark
# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.csv benchmark

# # sleep 5m

# # echo 'Get costs after running - Initial Date: '$INITIAL_DATE_AFTER ' | Final Date: '$FINAL_DATE_AFTER
# # echo $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > benchmark/time_after.txt
# # kubectl cost pod -n benchmark --show-all-resources --window $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > benchmark/cost_after_benchmark.csv

# echo '########## Benchmark Test 300 users 01 spawn rate 10 minutes finished ##########'

# #######################################################################################################################################################################################################

# echo '########## All-In-One Test 300 users 01 spawn rate 10 minutes ##########'

# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no all-in-one/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

# # INITIAL_DATE_BEFORE=$(date -u -d "-11 minute" +"%FT%H:%M:%SZ")
# # FINAL_DATE_BEFORE=$(date -u -d "-1 minute" +"%FT%H:%M:%SZ")
# # echo 'Get costs before running - Initial Date: '$INITIAL_DATE_BEFORE ' | Final Date: '$FINAL_DATE_BEFORE
# # echo $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > all-in-one/time_before.txt
# # kubectl cost pod -n all-in-one --show-all-resources --window $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > all-in-one/cost_before_all-in-one.csv

# echo 'Run Locust workload'
# kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# # INITIAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

# sleep 10.5m

# # FINAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

# kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.html all-in-one
# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.csv all-in-one

# # sleep 5m

# # echo 'Get costs after running - Initial Date: '$INITIAL_DATE_AFTER ' | Final Date: '$FINAL_DATE_AFTER
# # echo $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > all-in-one/time_after.txt
# # kubectl cost pod -n all-in-one --show-all-resources --window $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > all-in-one/cost_after_all-in-one.csv

# echo '########## All-In-One Test 300 users 01 spawn rate 10 minutes finished ##########'

# #######################################################################################################################################################################################################

# echo '########## By-Stack Test 300 users 01 spawn rate 10 minutes ##########'

# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no by-stack/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

# # INITIAL_DATE_BEFORE=$(date -u -d "-11 minute" +"%FT%H:%M:%SZ")
# # FINAL_DATE_BEFORE=$(date -u -d "-1 minute" +"%FT%H:%M:%SZ")
# # echo 'Get costs before running - Initial Date: '$INITIAL_DATE_BEFORE ' | Final Date: '$FINAL_DATE_BEFORE
# # echo $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > by-stack/time_before.txt
# # kubectl cost pod -n by-stack --show-all-resources --window $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > by-stack/cost_before_by-stack.csv

# echo 'Run Locust workload'
# kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# # INITIAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

# sleep 10.5m

# # FINAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

# kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.html by-stack
# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.csv by-stack

# # sleep 5m

# # echo 'Get costs after running - Initial Date: '$INITIAL_DATE_AFTER ' | Final Date: '$FINAL_DATE_AFTER
# # echo $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > by-stack/time_after.txt
# # kubectl cost pod -n by-stack --show-all-resources --window $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > by-stack/cost_after_by-stack.csv

# echo '########## By-Stack Test 300 users 01 spawn rate 10 minutes finished ##########'

# #######################################################################################################################################################################################################

# echo '########## By-Dependencies Test 300 users 01 spawn rate 10 minutes ##########'

# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no by-dependencies/locust.conf ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp

# # INITIAL_DATE_BEFORE=$(date -u -d "-11 minute" +"%FT%H:%M:%SZ")
# # FINAL_DATE_BEFORE=$(date -u -d "-1 minute" +"%FT%H:%M:%SZ")
# # echo 'Get costs before running - Initial Date: '$INITIAL_DATE_BEFORE ' | Final Date: '$FINAL_DATE_BEFORE
# # echo $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > by-dependencies/time_before.txt
# # kubectl cost pod -n by-dependencies --show-all-resources --window $INITIAL_DATE_BEFORE,$FINAL_DATE_BEFORE > by-dependencies/cost_before_by-dependencies.csv


# echo 'Run Locust workload'
# kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# # INITIAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

# sleep 10.5m

# # FINAL_DATE_AFTER=$(date -u -d "+1 minute" +"%FT%H:%M:%SZ")

# kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.html by-dependencies
# scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@ec2-15-229-77-7.sa-east-1.compute.amazonaws.com:/tmp/*.csv by-dependencies

# # sleep 5m

# # echo 'Get costs after running - Initial Date: '$INITIAL_DATE_AFTER ' | Final Date: '$FINAL_DATE_AFTER
# # echo $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > by-dependencies/time_after.txt
# # kubectl cost pod -n by-dependencies --show-all-resources --window $INITIAL_DATE_AFTER,$FINAL_DATE_AFTER > by-dependencies/cost_after_by-dependencies.csv

# echo '########## By-Dependencies Test 300 users 01 spawn rate 10 minutes finished ##########'

# #Copy Results
# FOLDER_DATE=$(date +"%Y%m%d")
# WORKLOAD_USERS=300
# mkdir -p ../../../experiments_results/$FOLDER_DATE

# mkdir -p ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS
# mkdir -p ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/benchmark
# cp benchmark/results.html ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/benchmark
# cp benchmark/${CSV_PREFIX}_stats.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/benchmark
# cp benchmark/${CSV_PREFIX}_stats_history.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/benchmark
# cp benchmark/${CSV_PREFIX}_failures.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/benchmark

# mkdir -p ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/all-in-one
# cp all-in-one/results.html ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/all-in-one
# cp benchmark/${CSV_PREFIX}_stats.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/all-in-one
# cp benchmark/${CSV_PREFIX}_stats_history.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/all-in-one
# cp benchmark/${CSV_PREFIX}_failures.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/all-in-one


# mkdir -p ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-stack
# cp by-stack/results.html ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-stack
# cp benchmark/${CSV_PREFIX}_stats.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-stack
# cp benchmark/${CSV_PREFIX}_stats_history.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-stack
# cp benchmark/${CSV_PREFIX}_failures.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-stack

# mkdir -p ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-dependencies
# cp by-dependencies/results.html ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-dependencies
# cp benchmark/${CSV_PREFIX}_stats.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-dependencies
# cp benchmark/${CSV_PREFIX}_stats_history.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-dependencies
# cp benchmark/${CSV_PREFIX}_failures.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/by-dependencies
