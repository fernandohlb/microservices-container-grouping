echo 'Delete all Resources'

for i in $SCENARIOS
do 
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/user-db/
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/manifests/microservices/
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/autoscaling/
    kubectl delete -f ../infrastructure/kubernetes-deploy/$i/manifests/
done