#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh

# Check context
. $WORKDIR/ops/set_context.sh


printf "${CCGREEN}DEPLOYING IN ${K8S_NAMESPACE} ${CCEND}\n"
for APP in `find app_* -mindepth 0 -maxdepth 0 -type d`; do \
    printf "${CCBLUE}deploying $APP ${CCEND}\n";\
    test -f $APP/deploy/kustomization && kubectl -n $K8S_NAMESPACE apply -k $APP/deploy ;\
    kubectl -n $K8S_NAMESPACE apply -f $APP/deploy/;\
done
kubectl -n $K8S_NAMESPACE get all