#!/usr/bin/env bash
. $WORKDIR/ops/defaults.sh



if [[ "true" == $CI ]]
then
    echo $GCP_CA_JSON | base64 -d > key.json && \
    gcloud auth activate-service-account \
        "$GCP_USER@$GCP_PROJ_ID.iam.gserviceaccount.com" --key-file=key.json && \
    rm key.json
    echo $GCP_CA_JSON | base64 -d  | docker login -u _json_key \
    --password-stdin https://$GCP_HOSTNAME 2> /dev/null
else
    gcloud config set account $GCP_USER@$GCP_PROJ_ID.iam.gserviceaccount.com
fi


if ! find .context -mmin -15 -type f 2> /dev/null |  egrep '.*' > /dev/null
then
    gcloud config set project $GCP_PROJ_ID > /dev/null && \
    printf "Set project $CCGREEN OK$CCEND\n" ;\
    gcloud config set compute/zone $GCP_LOCATION > /dev/null && \
    printf "Set gcp zone $CCGREEN OK$CCEND\n" ;\
    gcloud container clusters get-credentials $GCP_PROJ_ID > /dev/null && \
    printf "Set cluster $CCGREEN OK$CCEND\n" ;\
    gcloud beta container clusters update  $GCP_PROJ_ID \
    --update-addons=GcePersistentDiskCsiDriver=ENABLED > /dev/null && \
    printf '\e[A\e[K' && printf "$$CC $CCGREEN OK$CCEND\n" ;\
    echo "" > .context;\
fi
