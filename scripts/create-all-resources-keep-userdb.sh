echo 'Create all Resources'

for i in $SCENARIOS
do 
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/
    #kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/infraservices/user-db/
    sleep 30s
    kubectl apply -f ../infrastructure/kubernetes-deploy/$i/manifests/microservices/
done