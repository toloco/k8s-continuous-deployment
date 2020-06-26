#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh


for APP in `find app_* -mindepth 0 -maxdepth 0 -type d`
do
    echo "Building images for $APP"
    for DC in ./$APP/build/*Dockerfile
    do
        docker pull $GCP_HOSTNAME/$GCP_PROJ_ID/$APP:latest
        docker build \
        -t $GCP_HOSTNAME/$GCP_PROJ_ID/$APP \
        -f $DC \
        --cache-from $GCP_HOSTNAME/$GCP_PROJ_ID/$APP \
        ./$APP
    done 
done