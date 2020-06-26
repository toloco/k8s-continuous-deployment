#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh

cli_help() {
  printf "${CCGREEN}Deploy${CCEND} a specific commit to a namespace
  $1 namespace
  $2 commit-id,  optional, if not provided 'latest' tag will be used 

  example:
  \$cli deploy stag 22610e2cbb8c87ef9ebe9bf7075b337e0fa4ac69
"
 exit 0 
}

[[ "help" == $1 ]] && cli_help && exit 0

# Check context
. $WORKDIR/ops/set_context.sh

K8S_NAMESPACE=${1:-$K8S_NAMESPACE}
TAG=${2:-latest}


printf "${CCGREEN}DEPLOYING TO ${K8S_NAMESPACE} TAG ${TAG} ${CCEND}\n"

for APP in `find app_* -mindepth 0 -maxdepth 0 -type d`
do 
    printf "${CCBLUE}deploying $APP ${CCEND}\n"
    test -f $APP/deploy/kustomization && kubectl -n $K8S_NAMESPACE apply -k $APP/deploy
    kubectl -n $K8S_NAMESPACE apply -f $APP/deploy/
done

kubectl -n $K8S_NAMESPACE get all