echo 'Delete all Namespaces'
date --utc +%Y%m%d_%H:%M:%SZ
kubectl delete namespace benchmark
# kubectl delete namespace all-in-one
# kubectl delete namespace by-stack
# kubectl delete namespace by-dependencies

echo 'Create all Namespaces'
date --utc +%Y%m%d_%H:%M:%SZ
kubectl apply -f ../infrastructure/kubernetes-deploy/benchmark/manifests/infraservices/
# kubectl apply -f ../infrastructure/kubernetes-deploy/all-in-one/manifests/infraservices/
# kubectl apply -f ../infrastructure/kubernetes-deploy/by-stack/manifests/infraservices/
# kubectl apply -f ../infrastructure/kubernetes-deploy/by-dependencies/manifests/infraservices/

sleep 30s

echo 'Create Users in Databases'
date --utc +%Y%m%d_%H:%M:%SZ

kubectl port-forward -n benchmark deployment/user-db 27017 & 

sleep 10s
sh db/mongo_create_insert.sh
pkill kubectl -9

# kubectl port-forward -n all-in-one deployment/user-db 27017 & 

# sleep 10s
# sh db/mongo_create_insert.sh
# pkill kubectl -9

# kubectl port-forward -n by-stack deployment/user-db 27017 & 

# sleep 10s
# sh db/mongo_create_insert.sh
# pkill kubectl -9

# kubectl port-forward -n by-dependencies deployment/user-db 27017 & 

# sleep 10s
# sh db/mongo_create_insert.sh
# pkill kubectl -9 

kubectl apply -f ../infrastructure/kubernetes-deploy/benchmark/manifests/microservices/
# kubectl apply -f ../infrastructure/kubernetes-deploy/all-in-one/manifests/microservices/
# kubectl apply -f ../infrastructure/kubernetes-deploy/by-stack/manifests/microservices/
# kubectl apply -f ../infrastructure/kubernetes-deploy/by-dependencies/manifests/microservices/

kubectl apply -f ../infrastructure/kubernetes-deploy/benchmark/autoscaling/cart-hsc.yaml

echo 'Scenarios created at: '
date --utc +%Y%m%d_%H:%M:%SZ