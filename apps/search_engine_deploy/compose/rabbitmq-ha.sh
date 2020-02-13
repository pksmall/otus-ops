#!/usr/bin/env bash
# using helm2

# rebbitmq-ha
helm install stable/rabbitmq-ha --namespace rabbit -f rabbit-values.yaml

# service
export servicename=$(kubectl get services -n rabbit | grep rabbitmq-ha | grep -v discovery | awk '{print $1'})

# path port
kubectl patch service $servicename --namespace=rabbit --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value":31000}]'
