default_target: run

run: lint
	@echo "+"
	ansible-playbook ./playbooks/site.yml

run-prod: lint
	@echo "+"
	ansible-playbook -i environments/prod/inventory ./playbooks/site.yml

check:
	@echo "+"
	ansible-playbook ./playbooks/site.yml --check

check-prod:
	@echo "+"
	ansible-playbook -i environments/prod/inventory ./playbooks/site.yml --check

lint:
	@echo "+"
	ansible-lint ./playbooks/site.yml --exclude=./roles/jdauphant.nginx

lint-prod:
	@echo "+"
	ansible-lint ./playbooks/site.yml --exclude=./roles/jdauphant.nginx

install:
	ansible-galaxy install -r environments/stage/requirements.yml

install-prod:
	ansible-galaxy install -r environments/prod/requirements.yml

encrypt:
	ansible-vault encrypt environments/stage/credentials.yml

encrypt-prod:
	ansible-vault encrypt environments/prod/credentials.yml

decrypt:
	ansible-vault decrypt environments/stage/credentials.yml

decrypt-prod:
	ansible-vault decrypt environments/prod/credentials.yml

edit:
	ansible-vault edit environments/stage/credentials.yml

edit-prod:
	ansible-vault edit environments/prod/credentials.yml

# Vagrant commands
up:
	vagrant up --provider libvirt --no-parallel

vagrant-box-add:
	vagrant box add --insecure generic/ubuntu1604

vagrant-chown:
	sudo chown -R sergey:sergey .vagrant
