SHELL = /usr/bin/env bash -xeuo pipefail

stack_name:=lambda-runtime-tweeter-lambda
template_path:=packaged.yml

isort:
	poetry run isort -rc src

black:
	poetry run black src

format: isort black

build:
	cd src/layer; \
	docker build -t my-build .; \
	docker run --name my-container my-build pip3 install -r requirements.txt -t ./python; \
	docker cp my-container:/workdir/python .; \
	docker rm my-container; \
	docker rmi my-build; \
	cd ../../

package: build
	poetry run sam package \
		--s3-bucket $$ARTIFACT_BUCKET \
		--output-template-file $(template_path) \
		--template-file sam.yml

deploy: package
	poetry run sam deploy \
		--stack-name $(stack_name) \
		--template-file $(template_path) \
		--capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
		--no-fail-on-empty-changeset \
		--role-arn $$CLOUDFORMATION_DEPLOY_ROLE_ARN

.PHONY: \
	deploy \
	package \
	build \
	isort \
	black \
	format
