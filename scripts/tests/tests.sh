echo '########## Benchmark Test 01 user 01 spawn rate 10 minutes ##########'

scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no 01u01sr10m/benchmark/locust.conf ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/deploy-docs-k8s.pem ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp/results.html 01u01sr10m/benchmark
echo '########## Benchmark Test 01 user 01 spawn rate 10 minutes finished ##########'


echo '########## All-In-One Test 01 user 01 spawn rate 10 minutes ##########'

#scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no locustfile.py ec2-user@ec2-15-228-174-255.sa-east-1.compute.amazonaws.com:/tmp
scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no 01u01sr10m/all-in-one/locust.conf ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/deploy-docs-k8s.pem ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp/results.html 01u01sr10m/all-in-one
echo '########## All-In-One Test 01 user 01 spawn rate 10 minutes finished ##########'

echo '########## By-Stack Test 01 user 01 spawn rate 10 minutes ##########'

scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no 01u01sr10m/by-stack/locust.conf ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/deploy-docs-k8s.pem ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp/results.html 01u01sr10m/by-stack
echo '########## By-Stack Test 01 user 01 spawn rate 10 minutes finished ##########'

echo '########## By-Dependencies Test 01 user 01 spawn rate 10 minutes ##########'

scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no 01u01sr10m/by-dependencies/locust.conf ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/deploy-docs-k8s.pem ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp/results.html 01u01sr10m/by-dependencies
echo '########## By-Dependencies Test 01 user 01 spawn rate 10 minutes finished ##########'
