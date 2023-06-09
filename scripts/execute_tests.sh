

LOAD_TEST_INSTANCE=ec2-18-230-11-217.sa-east-1.compute.amazonaws.com
FOLDER_DATE=$(date +"%Y%m%d")

./erase-and-create-for-tests.sh
sleep 5m

mkdir -p ../experiments_results/$FOLDER_DATE
for workload in "300" "2400" "4500"
do
    mkdir -p ../experiments_results/$FOLDER_DATE/$workload
    
    for sample in {1..5}
    do
        mkdir -p ../experiments_results/$FOLDER_DATE/$workload/$sample
        for i in "benchmark" "all-in-one" "by-stack" "by-dependencies"
        do
            echo '##########' $i 'Test '$workload' users ##########'
            scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no tests/$workload/$i/locust.conf ec2-user@$LOAD_TEST_INSTANCE:/tmp
            echo 'Run Locust workload'
            kubectl apply -f ../infrastructure/kubernetes-deploy/load-test/manifests/
            
            sleep 10.5m
            
            kubectl delete -f ../infrastructure/kubernetes-deploy/load-test/manifests/

            sleep 10s

            mkdir -p ../experiments_results/$FOLDER_DATE/$workload/$sample/$i

            scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE:/tmp/*.html ../experiments_results/$FOLDER_DATE/$workload/$sample/$i
            scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE:/tmp/*.csv ../experiments_results/$FOLDER_DATE/$workload/$sample/$i
            

            echo '########## '$i' Test' $WORKLOAD_USERS 'users ##########'
        
            ssh -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE "rm -rf /tmp/*.csv"

        done
        sleep 5m
        
        ./erase-and-create-for-tests.sh
        
        sleep 5m
    done
done



# for sample in {1..3}
# do
    
#     mkdir -p ../experiments_results/$FOLDER_DATE
#     mkdir -p ../experiments_results/$FOLDER_DATE/$sample
#     for workload in "300" "2400" "4500"
#     do
#         mkdir -p ../experiments_results/$FOLDER_DATE/$sample/$workload

#         for i in "benchmark" "all-in-one" "by-stack" "by-dependencies"
#         do
        
#             echo '##########' $i 'Test '$workload' users ##########'
#             scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem -o StrictHostKeyChecking=no tests/$workload/$i/locust.conf ec2-user@$LOAD_TEST_INSTANCE:/tmp
#             echo 'Run Locust workload'
#             kubectl apply -f ../infrastructure/kubernetes-deploy/load-test/manifests/
            
#             sleep 10.5m
            
#             kubectl delete -f ../infrastructure/kubernetes-deploy/load-test/manifests/

#             sleep 10s

#             mkdir -p ../experiments_results/$FOLDER_DATE/$sample/$workload/$i

#             scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE:/tmp/*.html ../experiments_results/$FOLDER_DATE/$sample/$workload/$i
#             scp -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE:/tmp/*.csv ../experiments_results/$FOLDER_DATE/$sample/$workload/$i
            

#             echo '########## '$i' Test' $WORKLOAD_USERS 'users ##########'
        
#             ssh -i ~/.ssh/MICROSERVICES-CONTAINER-GROUPING.pem ec2-user@$LOAD_TEST_INSTANCE "rm -rf /tmp/*.csv"
#         done
#         sleep 5m
        
#         ./erase-and-create-for-tests.sh
        
#         sleep 5m
        
#     done

# done
