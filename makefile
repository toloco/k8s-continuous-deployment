#!make

# Load .makerc
-include $(HOME)/.makerc

K8S_NAMESPACE ?= $(K8S_DEFAULT_NAMESPACE)

################################################################################
# Makefile internals
################################################################################
# Kube command with namespace
kube := kubectl -n $(K8S_NAMESPACE)

CCRED := \e[31m
CCBLUE := \e[36m
CCYELLOW := \e[33m
CCGREEN := \e[92m
CCEND := \e[0m

.PHONY: help

help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

--set-context:
	@gcloud config set project $(GCP_PROJ_ID) > /dev/null && \
		printf "$$CC $(CCGREEN) OK$(CCEND)\n"
	
	@gcloud config set compute/zone $(GCP_LOCATION) > /dev/null && \
		printf "$$CC $(CCGREEN) OK$(CCEND)\n"
	
	@gcloud container clusters get-credentials $(GCP_PROJ_ID) > /dev/null && \
		printf "$$CC $(CCGREEN) OK$(CCEND)\n"
	
	@gcloud beta container clusters update  $(GCP_PROJ_ID) \
	--update-addons=GcePersistentDiskCsiDriver=ENABLED > /dev/null && \
		printf "$$CC $(CCGREEN) OK$(CCEND)\n"

################################################################################
namespace: ## Deploy namespaces
	@for NN in $(K8S_NAMESPACES); do \
		kubectl apply -f k8s/$$NN/namespace.yml; \
		kubectl apply -f k8s/$$NN/ -n $$NN; \
	done

deploy: ## Deploy application to Kuberntes
	@printf "${CCGREEN}DEPLOYING OND ${K8S_NAMESPACE} ${CCEND}\n"
	@for APP in $(shell find app_* -mindepth 0 -maxdepth 0 -type d); do \
		printf "${CCBLUE}deploying $$APP ${CCEND}\n";\
        if [ "$(wildcard $$APP/deploy/kustomization.yml)" != "" ]; then\
        	$(kube) apply -k $$APP/deploy/;\
        fi; \
		$(kube) apply -f $$APP/deploy ;\
	done
	@$(kube) get all

build: ## Build docker images locally
	@for APP in $(shell find app_* -mindepth 0 -maxdepth 0 -type d); do \
		echo "Building images for $$APP";\
		for DC in ./$$APP/build/*Dockerfile; do \
 			docker build -f $$DC --tag k8s/$$APP $$APP;\
		done \
	done

push: build_images --set-context  ## Push docker images to GCP registry
	@for APP in $(shell find app_* -mindepth 0 -maxdepth 0 -type d); do \
		echo pushing $$APP; \
		docker tag k8s/$$APP $(GCP_HOSTNAME)/$(GCP_PROJ_ID)/$$APP; \
		docker push $(GCP_HOSTNAME)/$(GCP_PROJ_ID)/$$APP; \
	done

	# List images
	gcloud container images list --repository $(GCP_HOSTNAME)/$(GCP_PROJ_ID)

################################################################################
COMMANDS := docker docker-compose kubectl gcloud
check: --set-context ## Checks you can run the makefile
	@for CC in $(COMMANDS); do \
		type $$CC > /dev/null && printf "$$CC $(CCGREEN) OK$(CCEND)\n";\
	done

	@if [ "$(shell $(kube) auth can-i create deployments)" = "yes" ];\
	then\
        printf "Can create deployments $(CCGREEN)OK$(CCEND)\n"; \
    else \
    	printf "Can't create deployments $(CCRED)ERROR$(CCEND)\n";\
    fi

