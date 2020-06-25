#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh


for APP in `find app_* -mindepth 0 -maxdepth 0 -type d`
do
    echo "Building images for $APP"
    for DC in ./$APP/build/*Dockerfile
    do
        docker pull gcr.io/tolo-kubernetes/app_athena
        docker build -f $DC --tag k8s/$APP $APP
    done 
done