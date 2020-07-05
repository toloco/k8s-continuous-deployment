Boilerplate for Continuous deployment in Kubernetes
===================================================
Boilerplate for continuous deployment in Kubernetes<img height="26" width="26" src="https://cdn.jsdelivr.net/npm/simple-icons@v2/icons/kubernetes.svg" />
on GCP<img height="26" width="26" src="https://cdn.jsdelivr.net/npm/simple-icons@v2/icons/github.svg" />
using Github<img height="26" width="26" src="https://cdn.jsdelivr.net/npm/simple-icons@v2/icons/googlecloud.svg" />




## Setup
The main 2 tools you need to use is `gcloud` to manage GCP services and `kubectl` which
you need to manage the kubernetes cluster.

Most of the common operations are covered by the `./cli`

### 1. Install tools
#### Install GCP gcloud manager
Follow GCP instructions https://cloud.google.com/sdk/install

#### Install Kubetctl
`gcloud components install kubectl`

#### Install Docker engine
Install instructions follow https://docs.docker.com/engine/install/

#### [Optional] Install docker-compose
Install instructions follow https://docs.docker.com/compose/install/


### 2. Settings
For a simpler configuration create a file in your user directory called `.kube-test.rc` with 
the following variables setup.
```
K8S_NAMESPACES=dev stag prod
K8S_DEFAULT_NAMESPACE=dev
GCP_HOSTNAME=gcr.io
GCP_PROJ_ID=<GCP Project id>
GCP_LOCATION=<gcp location>
GCP_CA_JSON=<GCP service token>
GCP_USER=<GCP service user>
GCP_KLUSTER_NAME=<kubernetes-test>
```

* **K8S_NAMESPACES** List of desired namespaces
* **K8S_DEFAULT_NAMESPACE** Default namespace
* **GCP_HOSTNAME**
* **GCP_PROJ_ID**
* **GCP_LOCATION**
* **GCP_USER** GCP service user e.g. gcp-sa
* **GCP_KLUSTER_NAME** GCP Kubernetes kluster name
* **GCP_CA_JSON** Base64 encoded GCP Json certificate for service user



After the steps, simply check the installation with  `./cli check`


## How to use
`./cli help`

`./cli deploy` Will deploy to K8S_DEFAULT_NAMESPACE

`./cli deploy stag` Will deploy to stag namespace
...

## Folder structure
All folders prefixed by **app_** are considered Kubernetes Apps, which for an easier management
forces to have a particular structure.
```
app_xxx
  |_> build: all dockerfiles
  |_> deploy: all kubernetes configuration files, including databases, services, etc
...
```


## Troubleshouting

#### Lost kubectl config?
Running `kubectl get all` and getting this error:
>> The connection to the server localhost:8080 was refused - did you specify the right host or port?

Use `gcloud container clusters list` to get the list of clusters available at your GCP account
And then configure **kubectl** with the desired cluster credentials
`gcloud container clusters get-credentials <CLUSTER NAME> --zone <ZONE>`

