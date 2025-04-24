build:
	make -C app setup_python run_python_tests build

run: build
	make -C app run setup_dynamodb

clean:
	rm -rf app/__pycache__
	rm -rf app/.pytest_cache
	rm -rf app/venv
