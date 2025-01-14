#!/bin/bash

set -e

# Step 1: Create a simple Kind cluster
echo "Creating a Kind cluster..."
kind create cluster --name airflow-cluster --config ./kind-configs/kind-standalone.yaml

# Step 2: Set up kubectl to use the new Kind cluster
echo "Setting kubectl context to Kind cluster..."
export KUBEVIRT_CONTEXT="kind-airflow-cluster"
kubectl cluster-info --context kind-airflow-cluster

# Step 3: Install Helm (if not already installed)
if ! command -v helm &> /dev/null; then
  echo "Helm not found, installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
  echo "Helm is already installed."
fi

# Step 4: Add the official Apache Airflow Helm chart repository
echo "Adding Apache Airflow Helm chart repository..."
helm repo add apache-airflow https://airflow.apache.org
helm repo update

# Step 5: Create a namespace for Airflow
echo "Creating Airflow namespace..."
kubectl create namespace airflow

# Step 6: Create a values.yaml file for CeleryKubernetesExecutor configuration
cat <<EOF > values.yaml
executor: CeleryKubernetesExecutor
airflow:
  image:
    repository: apache/airflow
    tag: 2.7.0  # Change this to the desired version of Airflow
  defaultAirflowRepository: apache/airflow
  defaultAirflowVersion: 2.7.0
  defaultAirflowImageTag: "2.7.0"
  deploy:
    persistence:
      enabled: true
      size: 10Gi
    worker:
      replicas: 3
    flower:
      enabled: true
EOF

# Step 7: Install Airflow using Helm with the specified values
echo "Installing Airflow using Helm..."
helm install airflow apache-airflow/airflow --namespace airflow -f values.yaml

# Step 8: Set up Airflow UI and verify the installation
echo "Waiting for the Airflow web server to be deployed..."
kubectl rollout status deployment/airflow-webserver --namespace airflow

echo "Airflow web server is deployed! Access it via kubectl port-forward:"
echo "kubectl port-forward svc/airflow-webserver 8080:8080 --namespace airflow"
echo "Now you can access the Airflow UI at http://localhost:8080"

# Optional: Step 9: Clean up (you can skip this step if you want to keep the cluster)
# kind delete cluster --name airflow-cluster

echo "Airflow with CeleryKubernetesExecutor is up and running!"
