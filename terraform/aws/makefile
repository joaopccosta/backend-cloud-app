AWS_REGION=eu-west-1
ENV ?= dev

.PHONY: init plan apply destroy

init:
	terraform init 
	terraform workspace select $(ENV) || terraform workspace new $(ENV)

plan:
	terraform plan -var-file=../env/$(ENV).tfvars -out=plan.out

apply:
	terraform apply -var-file=../env/$(ENV).tfvars plan.out
	@echo "Run the following to export environment variables:"
	@echo "export DYNAMODB_ENDPOINT=$$(terraform output -raw dynamodb_endpoint)"
	@echo "export DYNAMODB_TABLE=$$(terraform output -raw dynamodb_table)"
	@echo "Refreshing kubeconfig for AWS EKS cluster..."
	aws eks update-kubeconfig --region $(AWS_REGION) --name $(ENV)-eks-cluster

destroy:
	terraform destroy -var-file=../env/$(ENV).tfvars
