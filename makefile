ENV ?= dev
AWS_ACCOUNT_ID ?= 416761359656 # default to aws account for dev environment
IMAGE_NAME ?= backend-cloud-app
VERSION ?=1.0.0

.PHONY: test build push build-local clean init-aws plan-aws apply-aws init-kubernetes plan-kubernetes apply-kubernetes destroy minikube-up minikube-down helm-dependency-update helm-deploy-local helm-deploy-env

test:
	make -C app setup_python test VERSION=$(VERSION)

build:
	make -C app setup_python test build VERSION=$(VERSION)

push:
	make -C app setup_python test build ecr-login ecr-push VERSION=$(VERSION)
	
build-local:
	make -C app setup_python test build-minikube VERSION=$(VERSION)

clean:
	rm -rf app/__pycache__
	rm -rf app/.pytest_cache
	rm -rf app/venv
	rm -rf app/.coverage

init-aws:
	make -C terraform/aws init ENV=$(ENV)

plan-aws:
	make -C terraform/aws plan ENV=$(ENV)

apply-aws:
	make -C terraform/aws apply ENV=$(ENV)

init-kubernetes:
	make -C terraform/kubernetes init ENV=$(ENV)

plan-kubernetes:
	make -C terraform/kubernetes plan ENV=$(ENV)

apply-kubernetes:
	make -C terraform/kubernetes apply ENV=$(ENV)

destroy:
	helm uninstall backend --namespace $(ENV)
	make -C terraform/kubernetes destroy ENV=$(ENV)
	make -C terraform/aws destroy ENV=$(ENV)

minikube-up:
	minikube start --cpus=4 --memory=6g --driver=docker
	minikube addons enable ingress
	minikube tunnel &

minikube-down:
	pkill -f "minikube tunnel" || true
	minikube stop

helm-dependency-update:
	helm dependency update helm/backend/

helm-deploy-env: helm-dependency-update
	helm upgrade --install backend ./helm/backend \
	-f helm/backend/values.yaml \
	--namespace $(ENV) \
	--set environment=$(ENV) \
	--set aws.accountId="$(AWS_ACCOUNT_ID)" \
	--set aws.irsa.roleName="$(ENV)-backend-irsa-role" \
	--atomic
	@echo "Your backend service is publicly accessible through:"
	kubectl describe service backend --namespace dev | grep "LoadBalancer Ingress" | awk '{print $$3}'

deploy-backend-local: helm-dependency-update
	kubectl delete -f helm/dynamodb-local/dynamodb-local.yaml --ignore-not-found
	kubectl apply -f helm/dynamodb-local/dynamodb-local.yaml
	kubectl wait --for=condition=ready pod -l app=dynamodb-local --timeout=600s
	helm upgrade --install backend ./helm/backend -f helm/backend/values.local.yaml --atomic
	@echo "Your backend service is publicly accessible through:"
	minikube service backend -n dev --url

deploy-backend-dev:
	$(MAKE) helm-deploy-env AWS_ACCOUNT_ID="416761359656" ENV="dev"

deploy-backend-staging:
	$(MAKE) helm-deploy-env AWS_ACCOUNT_ID="416761359656" ENV="staging"

deploy-backend-prod:
	$(MAKE) helm-deploy-env AWS_ACCOUNT_ID="416761359656" ENV="prod"

