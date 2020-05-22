#!/usr/bin/env bash

K8S_NAMESPACE=${K8S_NAMESPACE:-$K8S_DEFAULT_NAMESPACE}
CircleCI=${CircleCI:=false}

CCRED="\e[31m"
CCYELLOW="\e[33m"
CCGREEN="\e[92m"
CCEND="\e[0m"
