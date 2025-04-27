AWS_REGION=eu-west-1
ENV ?= dev

.PHONY: init plan apply destroy

init:
	terraform init -reconfigure
	terraform workspace select $(ENV) || terraform workspace new $(ENV)

plan:
	terraform workspace select $(ENV)
	terraform plan -var-file=../env/$(ENV).tfvars -out=plan.out

apply:
	terraform workspace select $(ENV)
	terraform apply -var-file=../env/$(ENV).tfvars plan.out
	@echo "Refreshing kubeconfig for AWS EKS cluster..."
	aws eks update-kubeconfig --region $(AWS_REGION) --name $(ENV)-eks-cluster

destroy:
	terraform workspace select $(ENV)
	terraform destroy -var-file=../env/$(ENV).tfvars
