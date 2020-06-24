#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh

circleci config validate
circleci local execute --job build \
 -e GCP_CA_JSON=$GCP_CA_JSON \
 -e GCP_USER=$GCP_USER \
 -e K8S_NAMESPACES=$K8S_NAMESPACES \
 -e K8S_DEFAULT_NAMESPACE=$K8S_DEFAULT_NAMESPACE \
 -e GCP_LOCATION=$GCP_LOCATION \
 -e GCP_HOSTNAME=$GCP_HOSTNAME \
 -e GCP_PROJ_ID=$GCP_PROJ_ID