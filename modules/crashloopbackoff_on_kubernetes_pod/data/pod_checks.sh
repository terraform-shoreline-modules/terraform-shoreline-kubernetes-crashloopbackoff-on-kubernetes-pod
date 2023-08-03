
#!/bin/bash

# Set the namespace and pod name variables
NAMESPACE=${NAMESPACE}
POD_NAME=${POD_NAME}

# Get the logs for the container
kubectl logs $POD_NAME -n $NAMESPACE

# Check the status of the container
kubectl describe pod $POD_NAME -n $NAMESPACE | grep -A 2 "Containers\{1\}"

# Check the status of the image
kubectl describe pod $POD_NAME -n $NAMESPACE | grep -A 2 "Image\{1\}"

# Check the image pull policy
kubectl describe pod $POD_NAME -n $NAMESPACE | grep -A 2 "Image Pull Policy\{1\}"

# Check the container image for issues
kubectl run -it --rm debug --image=${DEBUG_IMAGE} --restart=Never -- /bin/sh -c "wget -O - ${CONTAINER_IMAGE_URL} | tar xzvf - -C /dev/null"