#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh

# Check context
. $WORKDIR/ops/set_context.sh


cli_help() {
  printf "${CCGREEN}Push${CCEND} push all docker images to GCP registry.
By default tags image with git commit id, if argument is passed all images are going to be tagged with it:
cli push i-am-a-hash
"
  exit 1
}

[[ "help" == $1 ]] \
    && cli_help && exit 0


GIT_SHA=${GITHUB_SHA:=$1}
[[ -z $GIT_SHA ]] && printf "${CCRED}Need to provide a tag ${CCEND}\n" && exit 1


for APP in `find app_* -mindepth 0 -maxdepth 0 -type d`
do
    echo "pushing $APP"
    docker tag $GCP_HOSTNAME/$GCP_PROJ_ID/$APP $GCP_HOSTNAME/$GCP_PROJ_ID/$APP:$GIT_SHA
    docker push $GCP_HOSTNAME/$GCP_PROJ_ID/$APP:$GIT_SHA
done

# List images
gcloud container images list --repository $GCP_HOSTNAME/$GCP_PROJ_ID

