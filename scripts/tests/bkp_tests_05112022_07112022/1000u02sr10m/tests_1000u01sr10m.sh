echo 'Get Cost Before Test'
kubectl cost namespace --show-all-resources --window 2022-11-07T18:01:00Z,2022-11-07T19:00:00Z > cost_result_before.csv
echo '########## Benchmark Test 100 user 01 spawn rate 10 minutes ##########'

scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no benchmark/locust.conf ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/deploy-docs-k8s.pem ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp/results.html benchmark
echo '########## Benchmark Test 100 user 01 spawn rate 10 minutes finished ##########'


echo '########## All-In-One Test 100 user 01 spawn rate 10 minutes ##########'

#scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no locustfile.py ec2-user@ec2-15-228-174-255.sa-east-1.compute.amazonaws.com:/tmp
scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no all-in-one/locust.conf ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/deploy-docs-k8s.pem ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp/results.html all-in-one
echo '########## All-In-One Test 100 user 01 spawn rate 10 minutes finished ##########'

echo '########## By-Stack Test 100 user 01 spawn rate 10 minutes ##########'

scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no by-stack/locust.conf ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/deploy-docs-k8s.pem ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp/results.html by-stack
echo '########## By-Stack Test 01 user 100 spawn rate 10 minutes finished ##########'

echo '########## By-Dependencies Test 100 user 01 spawn rate 10 minutes ##########'

scp -i ~/.ssh/deploy-docs-k8s.pem -o StrictHostKeyChecking=no by-dependencies/locust.conf ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp

echo 'Run Locust workload'
kubectl apply -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

sleep 10.5m

kubectl delete -f ../../../infrastructure/kubernetes-deploy/load-test/manifests/

scp -i ~/.ssh/deploy-docs-k8s.pem ec2-user@ec2-15-228-45-208.sa-east-1.compute.amazonaws.com:/tmp/results.html by-dependencies
echo '########## By-Dependencies Test 100 user 01 spawn rate 10 minutes finished ##########'

echo 'Get Cost After Test'
kubectl cost namespace --show-all-resources --window 2022-11-07T19:01:00Z,2022-11-07T20:00:00Z > cost_result_after.csv
