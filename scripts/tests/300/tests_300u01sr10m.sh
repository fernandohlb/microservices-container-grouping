FOLDER_DATE=$(date +"%Y%m%d")
WORKLOAD_USERS=300
SPAWN_RATE=01
LOAD_TEST_INSTANCE=ec2-18-230-11-217.sa-east-1.compute.amazonaws.com

for i in "benchmark" "all-in-one" "by-stack" "by-dependencies"
do 
    echo '##########' $i 'Test '$WORKLOAD_USERS' users' $SPAWN_RATE' spawn rate 10 minutes ##########'
    scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no $i/locust.conf ec2-user@$LOAD_TEST_INSTANCE:/tmp
    echo 'Run Locust workload'
    kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/
    
    sleep 10.5m
    
    kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

    sleep 10s

    
    mkdir -p ../../../experiments_results/$FOLDER_DATE

    mkdir -p ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS
    mkdir -p ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/$i

    scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE:/tmp/*.html ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/$i
    scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE:/tmp/*.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/$i



    # cp $i/*.html ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/$i
    # cp $i/*.csv ../../../experiments_results/$FOLDER_DATE/$WORKLOAD_USERS/$i   
    echo '########## '$i' Test' $WORKLOAD_USERS 'users' $SPAWN_RATE' spawn rate 10 minutes finished ##########'
 
    ssh -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE "rm -rf /tmp/*.csv"
done