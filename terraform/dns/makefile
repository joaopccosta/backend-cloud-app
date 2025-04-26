AWS_REGION=eu-west-1
ENV ?= dev

.PHONY: init plan apply destroy fetch-alb-values

init:
	terraform init -reconfigure
	terraform workspace select $(ENV) || terraform workspace new $(ENV)

fetch-alb-values:
	@echo "Fetching ALB DNS Name and Zone ID..."
	$(eval BACKEND_ALB_DNS_NAME=$(shell kubectl get ingress backend -n $(ENV) -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'))
	$(eval BACKEND_ALB_ZONE_ID=$(shell aws elbv2 describe-load-balancers --region $(AWS_REGION) --output json | jq -r --arg dns_name "$(BACKEND_ALB_DNS_NAME)" '.LoadBalancers[] | select(.DNSName == $$dns_name) | .CanonicalHostedZoneId'))
	@echo "ALB DNS Name: $(BACKEND_ALB_DNS_NAME)"
	@echo "ALB Zone ID: $(BACKEND_ALB_ZONE_ID)"

plan: fetch-alb-values
	terraform workspace select $(ENV)
	terraform plan \
		-var-file=../env/$(ENV).tfvars \
		-var backend_alb_dns_name=$(BACKEND_ALB_DNS_NAME) \
		-var backend_alb_zone_id=$(BACKEND_ALB_ZONE_ID) \
		-out=plan.out

apply:
	terraform workspace select $(ENV)
	terraform apply plan.out

destroy: fetch-alb-values
	terraform workspace select $(ENV)
	terraform destroy -var-file=../env/$(ENV).tfvars \
	-var backend_alb_dns_name=$(BACKEND_ALB_DNS_NAME) \
	-var backend_alb_zone_id=$(BACKEND_ALB_ZONE_ID) 
