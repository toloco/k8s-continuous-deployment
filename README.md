[![GitHub issues](https://img.shields.io/github/issues/toloco/k8s-continuous-deployment?style=flat-square&message=ON)](https://github.com/toloco/k8s-continuous-deployment/issues)


[![Kubernetes](http://img.shields.io/static/v1?label=Kubernetes&color=green&style=flat-square&logo=kubernetes&message=ON)](https://kubernetes.io/)


Boilerplate for Continuous deployment in Kubernetes
===================================================
Boilerplate for continuous deployment in Kubernetes on GCP using Github

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
```

* **K8S_NAMESPACES** List of desired namespaces
* **K8S_DEFAULT_NAMESPACE** Default namespace
* **GCP_HOSTNAME**
* **GCP_PROJ_ID**
* **GCP_LOCATION**
* **GCP_CA_JSON** Base64 encoded GCP Json certificate for service user
* **GCP_USER** GCP service user e.g. circleci-sa


After the steps, simply check the installation with  `./cli check`


## How to use
`./cli help`

`./cli deploy` Will deploy to K8S_DEFAULT_NAMESPACE

`./cli deploy stag` Will deploy to stag namespace
...

## Folder structure
All folders prefixed by **app_** are considered Kubernetes Apps, which for an easier management
forces to have a particular structure.
app_xxx
  |_> build: all dockerfiles
  |_> deploy: all kubernetes configuration files, including databases, services, etc
...


## Troubleshouting

#### Lost kubectl config?
Running `kubectl get all` and getting this error:
>> The connection to the server localhost:8080 was refused - did you specify the right host or port?

Use `gcloud container clusters list` to get the list of clusters available at your GCP account
And then configure **kubectl** with the desired cluster credentials
`gcloud container clusters get-credentials <CLUSTER NAME> --zone <ZONE>`




## TODO:
- [X] Create multiple services connected with nginx
- [X] Expose nginx to the Internet
- [X] Makefile with build/push images
- [X] Makefile deploy services
- [X] Makefile create namespaces
- [X] Namespace deployments
- [X] Quotas for namespaces
- [X] Databases
- [X] Load balancer
- [X] Persistent volumens
- [X] Github build
- [X] Github deploy (by commit id)
- [X] Delete and recreate cluster
- [X] Check deploy credentials periodically
- [X] Health checks
- [X] Autocreate secrets
- [ ] Customize deployments with kustomization tool
- [ ] Backups
- [ ] Performing a Rolling Update (zero downtime)
- [ ] Frontend
- [ ] Configmaps
- [ ] Github build cache
