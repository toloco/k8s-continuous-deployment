#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh

# Check context
. $WORKDIR/ops/set_context.sh


for NN in $K8S_NAMESPACES; do \
    echo $N;\
    kubectl apply -f k8s/$NN/namespace.yml; \
    kubectl apply -f k8s/$NN/ -n $NN; \
done
