ECR_REGISTRY ?= 416761359656.dkr.ecr.eu-west-1.amazonaws.com
ENV ?= dev
IMAGE_NAME ?= backend-cloud-app
TAG ?= latest
VERSION ?= 1.0.0

.PHONY: setup_python test test_with_coverage build build-minikube ecr-login ecr-push

setup_python:
	python -m venv venv && source venv/bin/activate && pip install -r requirements.txt

test:
	pytest -s -v

test_with_coverage:
	pytest --cov-report=term

build: test
	docker buildx build --platform=linux/arm64 -t backend-cloud-app:latest -t backend-cloud-app:$(VERSION) .
	docker tag backend-cloud-app:latest $(ECR_REGISTRY)/backend-cloud-app:latest
	docker tag backend-cloud-app:$(VERSION) $(ECR_REGISTRY)/backend-cloud-app:$(VERSION)

build-minikube: test
	@eval $$(minikube docker-env) && \
	docker buildx build --platform=linux/arm64 -t backend-cloud-app:latest .
	docker tag backend-cloud-app:$(VERSION)
	docker tag backend-cloud-app:latest

ecr-login:
	aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $(ECR_REGISTRY)

ecr-push:
	docker push $(ECR_REGISTRY)/backend-cloud-app:latest
	docker push $(ECR_REGISTRY)/backend-cloud-app:$(VERSION)
