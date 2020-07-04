#!/usr/bin/env bash


if [ -f $HOME/.kube-test.rc ];
then
    . $HOME/.kube-test.rc
fi

K8S_NAMESPACE=${K8S_NAMESPACE:-$K8S_DEFAULT_NAMESPACE}
CI=${CI:=false}
WHO=${GITHUB_ACTOR:=`whoami`}

CCRED="\e[31m"
CCYELLOW="\e[33m"
CCGREEN="\e[92m"
CCEND="\e[0m"

