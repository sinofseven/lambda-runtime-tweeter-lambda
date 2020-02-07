SHELL = /usr/bin/env bash -xeuo pipefail

stack_name:=lambda-runtime-tweeter-lambda
template_path:=.aws-sam/packaged.yml

isort:
	poetry run isort -rc src

black:
	poetry run black src

format: isort black

clean:
	find src -name requirements.txt | xargs rm -f

build: clean
	poetry install --no-dev
	poetry run pip freeze > src/tweet/requirements.txt
	poetry install
	poetry run sam build -t sam.yml --use-container

package: build
	poetry run sam package \
		--s3-bucket $$ARTIFACT_BUCKET \
		--output-template-file $(template_path)

deploy: package
	poetry run sam deploy \
		--stack-name $(stack_name) \
		--template-file $(template_path) \
		--capabilities CAPABILITY_IAM \
		--no-fail-on-empty-changeset \
		--role-arn $$CLOUDFORMATION_DEPLOY_ROLE_ARN

.PHONY: \
	deploy \
	package \
	build \
	isort \
	black \
	format
