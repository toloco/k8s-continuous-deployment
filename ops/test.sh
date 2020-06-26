#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh


for APP in `find app_* -mindepth 0 -maxdepth 0 -type d`; do \
    echo "Run tests for $APP";\
    for DC in ./$APP/build/*Dockerfile; do \
        docker run $GCP_HOSTNAME/$GCP_PROJ_ID/$APP test || exit 1;\
    done \
done