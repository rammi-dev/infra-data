Create admin token
kubectl -n kubernetes-dashboard create token admin-user

Proxy to K8s dashboard 
kubectl port-forward -n kubernetes-dashboard svc/kubernetes-dashboard 10002:443

Check status of airflow
helm status airflow --namespace airflow