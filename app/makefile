setup_python:
	python -m venv venv && source venv/bin/activate && pip install -r requirements.txt

test:
	pytest -s -v

test_with_coverage:
	pytest --cov=src --cov-report=term

build:
	docker build -t hello-world-cloud-app .

run:
	docker compose up --build

setup_dynamodb:
	AWS_PAGER="" aws dynamodb create-table \
	--endpoint-url http://localhost:8000 \
	--table-name Users \
	--attribute-definitions AttributeName=username,AttributeType=S \
	--key-schema AttributeName=username,KeyType=HASH \
	--billing-mode PAY_PER_REQUEST \
	--region us-east-1 \
	--profile default
