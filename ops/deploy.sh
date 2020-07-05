#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh

cli_help() {
  printf "${CCGREEN}Deploy${CCEND} a specific commit to a namespace
  $1 namespace
  $2 commit-id,  optional, if not provided 'latest' tag will be used
  $3 app [optional] full app name, default all apps

  example:
  \$cli deploy stag 22610e2cbb8c87ef9ebe9bf7075b337e0fa4ac69 app_athena
"
 exit 0 
}

[[ "help" == $1 ]] && cli_help && exit 0


deploy_app(){
    K8S_NAMESPACE=$1
    APP=$2
    GIT_SHA=$3

    # printf "${CCBLUE}deploying $APP ${CCEND}\n"

    [[ -f $APP/deploy/kustomization ]] && kubectl -n $K8S_NAMESPACE -k $APP/deploy --dry-run -o yaml
    
    # kubectl -n $K8S_NAMESPACE apply -f $APP/deploy/

    # printf "${CCGREEN}OK${CCEND}\n"
}

# Check context
. $WORKDIR/ops/set_context.sh

K8S_NAMESPACE=${1:-$K8S_NAMESPACE}
TAG=${GITHUB_SHA:=$2}

[[ -z $TAG ]] && printf "${CCRED}Need to provide a tag ${CCEND}\n" && exit 1


printf "${CCGREEN}DEPLOYING TO ${K8S_NAMESPACE} TAG ${TAG} ${CCEND}\n"

if [[ -z $3 ]]
then
    for APP in `find app_* -mindepth 0 -maxdepth 0 -type d`
    do 
        deploy_app $K8S_NAMESPACE $APP $TAG
    done
else
    deploy_app $K8S_NAMESPACE $3 $TAG
fi

# Fetch deployment status
# kubectl -n $K8S_NAMESPACE get all
