
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# CrashloopBackOff on Kubernetes Pod
---

CrashloopBackOff on a Kubernetes Pod is an incident that occurs when a container running in a Kubernetes Pod repeatedly crashes immediately after starting up. This could be caused by a variety of factors, such as a bad deployment, an issue with the Pod's configuration, or a problem with the underlying infrastructure. This incident can cause disruption to the application or service running in the Pod and needs to be resolved as quickly as possible.

### Parameters
```shell
# Environment Variables
export POD_NAME="PLACEHOLDER"
export NAMESPACE="PLACEHOLDER"
export CONTAINER_NAME="PLACEHOLDER"
export DEBUG_IMAGE="PLACEHOLDER"
export CONTAINER_IMAGE_URL="PLACEHOLDER"

```

## Debug

### Find the Pod that is in CrashloopBackOff state
```shell
kubectl get pods -n ${NAMESPACE} | grep ${POD_NAME}
```

### View the logs of the container that is crashing
```shell
kubectl logs ${POD_NAME} -c ${CONTAINER_NAME} -n ${NAMESPACE}
```

### Get a detailed description of the Pod to check for any issues
```shell
kubectl describe pod ${POD_NAME} -n ${NAMESPACE}
```

### Check the events related to the Pod to see if there are any warnings or errors
```shell
kubectl get events -n ${NAMESPACE} | grep ${POD_NAME}
```

### Check the resource usage of the Pod and its containers to ensure they are not exceeding limits
```shell
kubectl top pod ${POD_NAME} -n ${NAMESPACE}
kubectl top container ${CONTAINER_NAME} -p ${POD_NAME} -n ${NAMESPACE}
```
### Image Issues: The container image could be misconfigured or corrupted, causing the container to fail repeatedly immediately after starting up.
```shell

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

```

---

## Repair
---

### Verify Pod configuration: Verify the configuration of the Pod to ensure that it is correctly configured and that there are no errors in the configuration files.
```shell

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

```

### Restart the Pod: Restarting the Pod may help resolve the issue if the cause of the incident is a transient issue.
```shell

#!/bin/bash

# Set the name of the Kubernetes Pod
POD_NAME=${POD_NAME}

# Set the namespace of the Kubernetes Pod
NAMESPACE=${NAMESPACE}

# Restart the Kubernetes Pod
kubectl delete pod $POD_NAME -n $NAMESPACE

bash script.sh

```
---