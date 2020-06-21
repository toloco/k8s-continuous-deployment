#!/usr/bin/env bash

. $HOME/.kube-test.rc

K8S_NAMESPACE=${K8S_NAMESPACE:-$K8S_DEFAULT_NAMESPACE}
CircleCI=${CircleCI:=false}

CCRED="\e[31m"
CCYELLOW="\e[33m"
CCGREEN="\e[92m"
CCEND="\e[0m"


# Check is the right context
check_env() {
# Check env is not CircleCI
    [[ "true" == $CircleCI ]] \
        && echo "Can't run in CircleCI" && exit 1
}
