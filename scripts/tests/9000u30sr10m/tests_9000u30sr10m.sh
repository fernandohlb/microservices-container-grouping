FOLDER_DATE=$(date +"%Y%m%d")
WORKLOAD_USERS=9000
SPAWN_RATE=30

#declare -a arr=("benchmark" "all-in-one" "by-stack" "by-dependencies")

for i in "benchmark"
# "all-in-one" "by-stack" "by-dependencies"
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
 
done