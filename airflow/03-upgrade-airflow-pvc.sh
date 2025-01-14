#!/bin/bash

mkdir -p /mnt/data/airflow/dags
mkdir -p /mnt/data/airflow/logs
# Define the PVC YAML file path
PVC_YAML="pvc-airflow-dags.yaml"
NAMESPACE="airflow"  # You can change the namespace if required

# Apply the PVC YAML
kubectl apply -f "$PVC_YAML" -n "$NAMESPACE"
    
# Check if the PVC was created successfully
echo "Checking PVC status..."
kubectl get pvc -n "$NAMESPACE" "$PVC_NAME"
    
if kubectl get pvc -n "$NAMESPACE" "$PVC_NAME" | grep -q 'Bound'; then
   echo "PVC $PVC_NAME successfully created/upgraded and is bound."
else
   echo "PVC $PVC_NAME failed to bind. Please check the PVC configuration."
fi
}



helm upgrade airflow apache-airflow/airflow \
  -f kind-configs/airflow-values.yaml \
  --namespace airflow \
  --install
