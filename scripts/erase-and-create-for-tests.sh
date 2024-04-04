echo 'Delete all Namespaces'
date --utc +%Y%m%d_%H:%M:%SZ

for i in "benchmark" "all-in-one" "by-stack" "by-dependencies"
do 
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/
done

sleep 30s

for i in "benchmark" "all-in-one" "by-stack" "by-dependencies"
do 
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/manifests/microservices/
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/autoscaling/
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/microservices/
done


echo 'Scenarios created at: '
date --utc +%Y%m%d_%H:%M:%SZ