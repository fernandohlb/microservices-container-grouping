echo 'Delete all Namespaces'
date --utc +%Y%m%d_%H:%M:%SZ

for i in "benchmark" "all-in-one" "by-stack" "by-dependencies"
do 
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/user-db/
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/user-db/

    sleep 30s
    echo 'Create Users in Databases'
    date --utc +%Y%m%d_%H:%M:%SZ
    kubectl port-forward -n $i deployment/user-db 27017 & 

    sleep 10s
    sh db/mongo_create_insert.sh
    pkill kubectl -9

done

sleep 30s

for i in "benchmark" "all-in-one" "by-stack" "by-dependencies"
do 
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/manifests/microservices/
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/microservices/
done


echo 'Scenarios created at: '
date --utc +%Y%m%d_%H:%M:%SZ