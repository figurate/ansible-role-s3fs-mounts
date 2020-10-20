SHELL:=/bin/bash
ANSIBLE_VERSION=latest
ANSIBLE=docker run --rm -v "${PWD}:/work" -v "${HOME}:/root" -e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) -e http_proxy=$(http_proxy) --net=host -w /work willhallonline/ansible:$(ANSIBLE_VERSION)

ANSIBLE_LINT=docker run --rm -v "${PWD}:/data" cytopia/ansible-lint

DIAGRAMS=docker run -t -v "${PWD}:/work" figurate/diagrams python

ANSIBLE_AUTODOC=docker run --rm -v "${PWD}:/work" figurate/ansible-autodoc ansible-autodoc -y

EXAMPLE=$(wordlist 2, $(words $(MAKECMDGOALS)), $(MAKECMDGOALS))

.PHONY: all clean validate test diagram docs format

all: validate test docs format

clean:
	rm -rf .terraform/

validate:
	$(ANSIBLE) ansible-playbook tests/default.yml --syntax-check

test: validate
	$(ANSIBLE) ansible-playbook tests/default.yml --skip-tags "production"

diagram:
	$(DIAGRAMS) diagram.py

docs: diagram
	$(ANSIBLE_AUTODOC)

format:
	$(ANSIBLE_LINT)

example:
	$(TERRAFORM) init examples/$(EXAMPLE) && $(TERRAFORM) plan -input=false examples/$(EXAMPLE)
