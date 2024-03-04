#!/bin/bash

# Namespace where the PTP pod is running
NAMESPACE="default"
# Label selector to identify the PTP pod
LABEL_SELECTOR="app=ptp"

# Kubernetes API server URL
APISERVER="https://kubernetes.default.svc"
# Path to the service account token and CA certificate
TOKEN_PATH="/var/run/secrets/kubernetes.io/serviceaccount/token"
CA_CERT="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"

# Read the service account token
TOKEN=$(cat "${TOKEN_PATH}")

# Use curl to query the Kubernetes API for pods matching the label selector in the namespace
RESPONSE=$(curl -s --cacert ${CA_CERT} -H "Authorization: Bearer ${TOKEN}" \
  "${APISERVER}/api/v1/namespaces/${NAMESPACE}/pods?labelSelector=${LABEL_SELECTOR}")

# Extract the 'Ready' status condition for the first pod in the response
IS_READY=$(echo ${RESPONSE} | jq -r '.items[0].status.conditions[] | select(.type=="Ready").status')

# Check the 'Ready' status
if [ "${IS_READY}" == "True" ]; then
  echo "PTP pod is ready."
  # Exit with 0 to indicate success/no problem
  exit 0
else
  echo "PTP pod is not ready."
  # Exit with 1 or appropriate code to indicate a problem
  exit 1
fi
