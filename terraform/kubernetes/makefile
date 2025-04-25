AWS_REGION=eu-west-1
ENV ?= dev
AWS_USERNAME ?= fake

.PHONY: init plan apply destroy

init:
	terraform init 
	terraform workspace select $(ENV) || terraform workspace new $(ENV)

plan:
	terraform plan -var-file=../env/$(ENV).tfvars -var aws_username=$(AWS_USERNAME) -out=plan.out

apply:
	terraform apply -var-file=../env/$(ENV).tfvars plan.out -var aws_username=$(AWS_USERNAME)

destroy:
	terraform destroy -var-file=../env/$(ENV).tfvars -var aws_username=$(AWS_USERNAME)

