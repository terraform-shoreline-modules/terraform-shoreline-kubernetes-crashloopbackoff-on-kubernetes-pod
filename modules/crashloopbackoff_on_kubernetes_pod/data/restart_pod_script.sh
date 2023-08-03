
#!/bin/bash

# Set the name of the Kubernetes Pod
POD_NAME=${POD_NAME}

# Set the namespace of the Kubernetes Pod
NAMESPACE=${NAMESPACE}

# Restart the Kubernetes Pod
kubectl delete pod $POD_NAME -n $NAMESPACE

bash script.sh