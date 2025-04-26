AWS_REGION=eu-west-1
ENV ?= dev
AWS_USERNAME ?= some-username

.PHONY: init plan apply destroy

init:
	terraform init -reconfigure
	terraform workspace select $(ENV) || terraform workspace new $(ENV)

plan:
	terraform workspace select $(ENV)
	terraform plan -var-file=../env/$(ENV).tfvars -var aws_username=$(AWS_USERNAME) -out=plan.out

apply:
	terraform workspace select $(ENV)
	terraform apply plan.out

destroy:
	terraform workspace select $(ENV)
	terraform destroy -var-file=../env/$(ENV).tfvars -var aws_username=$(AWS_USERNAME)
