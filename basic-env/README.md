# Create cluster 

```bash
kind create cluster --config kind-standalone.yaml
k create ns postgresql
helm install postgres-operator postgres-operator-charts/postgres-operator -n postgresql
kubectl --namespace=postgresql get pods -l "app.kubernetes.io/name=postgres-operator"

# Create ns for postgres cluster 
```bash
k create ns postgressql-main
