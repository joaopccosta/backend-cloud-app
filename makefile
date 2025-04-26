ENV ?= dev
IMAGE_NAME ?= backend-cloud-app
VERSION ?=1.0.0
AWS_USERNAME ?= some-username

.PHONY: test build push build-local clean init-aws plan-aws apply-aws init-kubernetes plan-kubernetes apply-kubernetes init-dns plan-dns apply-dns destroy minikube-up minikube-down helm-dependency-update helm-deploy-local helm-deploy-env

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
	make -C terraform/kubernetes plan ENV=$(ENV) AWS_USERNAME=$(AWS_USERNAME)

apply-kubernetes:
	make -C terraform/kubernetes apply ENV=$(ENV)

init-dns:
	make -C terraform/dns init ENV=$(ENV)

plan-dns:
	make -C terraform/dns plan ENV=$(ENV)

apply-dns:
	make -C terraform/dns apply ENV=$(ENV)

destroy:
	make -C terraform/dns destroy ENV=$(ENV)
	# kubectl get namespace $(ENV) -o json | jq 'del(.spec.finalizers)' | kubectl replace --raw "/api/v1/namespaces/$(ENV)/finalize" -f -
	make -C terraform/kubernetes destroy ENV=$(ENV) AWS_USERNAME=$(AWS_USERNAME)
	make -C terraform/aws destroy ENV=$(ENV)

minikube-up:
	minikube start --cpus=4 --memory=6g --driver=docker
	minikube kubectl create namespace dev
	minikube addons enable ingress
	minikube tunnel &

minikube-down:
	pkill -f "minikube tunnel" || true
	minikube stop

helm-dependency-update:
	helm dependency update helm/backend/

deploy-backend-local: helm-dependency-update
	kubectl delete -f helm/dynamodb-local/dynamodb-local.yaml --ignore-not-found
	kubectl apply -f helm/dynamodb-local/dynamodb-local.yaml
	kubectl wait --for=condition=ready pod -l app=dynamodb-local --timeout=600s
	helm upgrade --install backend ./helm/backend -f helm/backend/values.local.yaml --atomic
	@echo "Your backend service is publicly accessible through:"
	minikube service backend -n dev --url
