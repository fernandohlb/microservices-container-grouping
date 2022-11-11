echo 'Delete all Namespaces'
kubectl delete namespace benchmark
kubectl delete namespace all-in-one
kubectl delete namespace by-stack
kubectl delete namespace by-dependencies

sleep 5m

echo 'Create all Namespaces'
kubectl apply -f ../infrastructure/kubernetes-deploy/benchmark/manifests/
kubectl apply -f ../infrastructure/kubernetes-deploy/all-in-one/manifests/
kubectl apply -f ../infrastructure/kubernetes-deploy/by-stack/manifests/
kubectl apply -f ../infrastructure/kubernetes-deploy/by-dependencies/manifests/

echo 'Scenarios created at: '
date --utc +%Y%m%d_%H:%M:%SZ