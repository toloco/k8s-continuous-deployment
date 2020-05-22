#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh

# Check context
. $WORKDIR/ops/set_context.sh



cli_help() {
  printf "${CCGREEN}push${CCEND} Build and push docker images to GCP registry.
By default tags image with git commit id, if argument is passed all images are going to be tagged with it:
cli push i-am-a-hash
"
  exit 1
}

[[ "help" == $1 ]] \
    && cli_help && exit 0


for APP in `find app_* -mindepth 0 -maxdepth 0 -type d`; do \
    echo pushing $APP; \
    echo `git log -1 --format="%H"`;\
    echo $GCP_HOSTNAME/$GCP_PROJ_ID/$APP; exit 0;/
    docker tag k8s/$APP $GCP_HOSTNAME/$GCP_PROJ_ID/$APP; \
    docker push $GCP_HOSTNAME/$GCP_PROJ_ID/$APP; 

done

# List images
gcloud container images list --repository $GCP_HOSTNAME/$GCP_PROJ_ID


