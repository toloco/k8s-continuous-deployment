export CLOUD_SDK_VERSION=291.0.0
export CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
export CLOUDSDK_PYTHON=python3
export PATH=/root/google-cloud-sdk/bin:$PATH

apk --no-cache add \
        curl \
        python3 \
        py3-crcmod \
        bash \
        alpine-sdk \
        libc6-compat \
        openssh-client \
        gnupg

curl -sSL https://sdk.cloud.google.com -o gcp_installer.bash
bash gcp_installer.bash --disable-prompts > /dev/null


echo $GCP_CA_JSON | base64 -d > key.json && \
gcloud auth activate-service-account \
    "$GCP_USER@$GCP_PROJ_ID.iam.gserviceaccount.com" --key-file=key.json && \
rm key.json

yes Y | gcloud auth configure-docker  --quiet > /dev/null
yes Y | gcloud components install kubectl  --quiet > /dev/null
