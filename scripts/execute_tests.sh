LOAD_TEST_INSTANCE=ec2-18-231-159-233.sa-east-1.compute.amazonaws.com
FOLDER_DATE=$(date +"%Y%m%d")
export SCENARIOS="benchmark all-in-one by-stack by-dependencies"
export WORKLOADS="300 2400 4500"

#export WORKLOADS="2400"


./delete-all-resources.sh
./create-all-resources.sh
sleep 5m

mkdir -p ../experiments_results/$FOLDER_DATE

for sample in {1..5}
do
    mkdir -p ../experiments_results/$FOLDER_DATE/$sample
    for workload in $WORKLOADS    
    do
        mkdir -p ../experiments_results/$FOLDER_DATE/$sample/$workload
        for i in $SCENARIOS
        do
            kubectl apply -f ../infrastructure/kubernetes-deploy/$i/autoscaling/
            #kubectl delete -f ../infrastructure/kubernetes-deploy/$i/autoscaling/front-end-hsc.yaml
            now="$(date)"
            echo '##########' $i 'Test /'$workload' users / Sample' $sample /' Sarted at: ' $now '##########'
            scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no tests/$workload/$i/locust.conf ec2-user@$LOAD_TEST_INSTANCE:/tmp
            echo 'Run Locust workload'
            kubectl apply -f ../infrastructure/kubernetes-deploy/load-test/manifests/
            
            sleep 10.5m
            
            kubectl delete -f ../infrastructure/kubernetes-deploy/load-test/manifests/

            sleep 10s

            mkdir -p ../experiments_results/$FOLDER_DATE/$sample/$workload/$i

            scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE:/tmp/*.html ../experiments_results/$FOLDER_DATE/$sample/$workload/$i
            scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE:/tmp/*.csv ../experiments_results/$FOLDER_DATE/$sample/$workload/$i
            

            now="$(date)"
            echo '##########' $i 'Test /'$workload' users / Sample' $sample /' Finished at: ' $now '##########'        
            ssh -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE "rm -rf /tmp/*.csv"

        done
        sleep 5m        
        ./delete-all-resources-keep-userdb.sh
        ./create-all-resources-keep-userdb.sh
        sleep 5m
    done
done

./delete-all-resources.sh
kubectl delete -f ../infrastructure/kubernetes-deploy/load-test/manifests/
