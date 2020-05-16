#!make

# Load .kube-test
-include $(HOME)/.kube-test.rc

K8S_NAMESPACE ?= $(K8S_DEFAULT_NAMESPACE)
CircleCI ?= false


################################################################################
# Makefile internals
################################################################################
# Kube command with namespace
kube := kubectl -n $(K8S_NAMESPACE)

CCRED := \e[31m
CCYELLOW := \e[33m
CCGREEN := \e[92m
CCEND := \e[0m

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' makefile | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'


################################################################################
namespace: --set-context ## Deploy namespaces
	@for NN in $(K8S_NAMESPACES); do \
		kubectl apply -f k8s/$$NN/namespace.yml; \
		kubectl apply -f k8s/$$NN/ -n $$NN; \
	done

deploy: --set-context ## Deploy application to Kuberntes
	@printf "${CCGREEN}DEPLOYING IN ${K8S_NAMESPACE} ${CCEND}\n"
	@for APP in $(shell find app_* -mindepth 0 -maxdepth 0 -type d); do \
		printf "${CCBLUE}deploying $$APP ${CCEND}\n";\
        test -f $$APP/deploy/kustomization && $(kube) apply -k $$APP/deploy ;\
		$(kube) apply -f $$APP/deploy/;\
	done
	@$(kube) get all

build:  ## Build docker images locally
	@for APP in $(shell find app_* -mindepth 0 -maxdepth 0 -type d); do \
		echo "Building images for $$APP";\
		for DC in ./$$APP/build/*Dockerfile; do \
 			docker build -f $$DC --tag k8s/$$APP $$APP;\
		done \
	done

push: build --set-context  ## Push docker images to GCP registry
	@for APP in $(shell find app_* -mindepth 0 -maxdepth 0 -type d); do \
		echo pushing $$APP; \
		docker tag k8s/$$APP $(GCP_HOSTNAME)/$(GCP_PROJ_ID)/$$APP; \
		docker push $(GCP_HOSTNAME)/$(GCP_PROJ_ID)/$$APP; \
	done

	# List images
	gcloud container images list --repository $(GCP_HOSTNAME)/$(GCP_PROJ_ID)

################################################################################
COMMANDS := docker kubectl gcloud
check: --set-context ## Checks you can run the makefile
	@for CC in $(COMMANDS); do \
		type $$CC > /dev/null 2> /dev/null && printf "$$CC $(CCGREEN) OK$(CCEND)\n";\
	done

	@if [ "$(shell $(kube) auth can-i create deployments)" = "yes" ];\
	then\
        printf "Can create deployments $(CCGREEN)OK$(CCEND)\n"; \
    else \
    	printf "Can't create deployments $(CCRED)ERROR$(CCEND)\n";\
    fi

--set-context: # Check if gcloud and kubectl are correctly logged in 
ifeq ($(CircleCI),true)
	echo "Login"
	echo $(GCP_CA_JSON) | base64 -d > key.json && \
	gcloud auth activate-service-account \
    	"$(GCP_USER)@$(GCP_PROJ_ID).iam.gserviceaccount.com" --key-file=key.json && \
    rm key.json
	echo $(GCP_CA_JSON) | base64 -d  | docker login -u _json_key \
	--password-stdin https://$(GCP_HOSTNAME)
endif
	@if ! find .context -mmin -15 -type f 2> /dev/null |  egrep '.*' > /dev/null; then\
		gcloud config set project $(GCP_PROJ_ID) > /dev/null && \
		printf "$$CC $(CCGREEN) OK$(CCEND)\n" ;\
		gcloud config set compute/zone $(GCP_LOCATION) > /dev/null && \
		printf "$$CC $(CCGREEN) OK$(CCEND)\n" ;\
		gcloud container clusters get-credentials $(GCP_PROJ_ID) > /dev/null && \
		printf "$$CC $(CCGREEN) OK$(CCEND)\n" ;\
		gcloud beta container clusters update  $(GCP_PROJ_ID) \
		--update-addons=GcePersistentDiskCsiDriver=ENABLED > /dev/null && \
		printf '\e[A\e[K' && printf "$$CC $(CCGREEN) OK$(CCEND)\n" ;\
		echo "" > .context;\
	fi

################################################################################
local-ci-exec:  ## Run CircleCI locally
	@circleci config validate
	@circleci local execute --job build \
	 -e GCP_CA_JSON=$(GCP_CA_JSON) \
	 -e GCP_USER=$(GCP_USER) \
	 -e K8S_NAMESPACES=$(K8S_NAMESPACES) \
	 -e K8S_DEFAULT_NAMESPACE=$(K8S_DEFAULT_NAMESPACE) \
	 -e GCP_LOCATION=$(GCP_LOCATION) \
	 -e GCP_HOSTNAME=$(GCP_HOSTNAME) \
	 -e GCP_PROJ_ID=$(GCP_PROJ_ID) \
