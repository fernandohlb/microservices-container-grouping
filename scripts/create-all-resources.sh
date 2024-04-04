echo 'Create all Resources'

for i in $SCENARIOS
do 
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/user-db/

    sleep 30s
    echo 'Create Users in Databases'
    date --utc +%Y%m%d_%H:%M:%SZ
    kubectl port-forward -n $i deployment/user-db 27017 & 

    sleep 10s
    sh db/mongo_create_insert.sh
    pkill kubectl -9
    sleep 30s
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/microservices/
done