kubectl top pod ${POD_NAME} -n ${NAMESPACE}
kubectl top container ${CONTAINER_NAME} -p ${POD_NAME} -n ${NAMESPACE}