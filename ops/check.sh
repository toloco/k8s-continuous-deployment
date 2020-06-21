#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh

# Check context
. $WORKDIR/ops/set_context.sh


for CC in "docker" "kubectl" "gcloud"; do \
    type $CC > /dev/null 2> /dev/null && printf "$CC $CCGREEN OK$CCEND\n";\
done

if [ `kubectl -n $K8S_NAMESPACE auth can-i create deployments` = "yes" ];\
then\
    printf "Can create deployments $CCGREEN OK $CCEND\n"; \
else \
    printf "Can't create deployments $CCRED ERROR $CCEND\n";\
fi
