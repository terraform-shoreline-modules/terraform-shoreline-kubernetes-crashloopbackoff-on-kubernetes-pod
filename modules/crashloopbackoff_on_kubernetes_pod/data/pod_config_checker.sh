
#!/bin/bash

# Set the namespace and Pod name
NAMESPACE=${NAMESPACE}
POD=${POD_NAME}

# Get the Pod configuration
kubectl get pod $POD -n $NAMESPACE -o yaml > pod.yaml

# Check for errors in the configuration file
if ! kubectl apply -f pod.yaml --dry-run > /dev/null; then
    echo "Pod configuration file contains errors"
    exit 1
fi

echo "Pod configuration is valid"