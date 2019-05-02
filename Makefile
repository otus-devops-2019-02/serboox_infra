
run: tf-apply ansible-up

destroy: tf-destroy-stage

# Packer commands
packer-build-app: tf-ssh-enable
	@echo "+ $@"
	packer build ./packer/app.json

packer-build-db: tf-ssh-enable
	@echo "+ $@"
	packer build ./packer/db.json

# Terraform commands
tf-apply: tf-img-update tf-fmt tf-validate
	@echo "+ $@"
	cd ./terraform/stage &&\
	terraform apply --auto-approve=true

tf-ssh-enable:
	@echo "+ $@"
	cd ./terraform/stage &&\
	terraform apply -target=module.vpc --auto-approve=true

tf-img-update: tf-update-app-img tf-update-db-img

tf-update-app-img:
	@echo "+ $@"
	gcloud compute images list --filter reddit-app --format text | grep name | awk '{print $$2}' | \
	xargs -I {} echo 'app_disk_image = \"{}\"' | \
	xargs -I {} sed -i 's/app_disk_image =.*/{}/g' ./terraform/stage/terraform.tfvars ./terraform/prod/terraform.tfvars

tf-update-db-img:
	@echo "+ $@"
	gcloud compute images list --filter reddit-db --format text | grep name | awk '{print $$2}' | \
	xargs -I {} echo 'db_disk_image = \"{}\"' | \
	xargs -I {} sed -i 's/db_disk_image =.*/{}/g' ./terraform/stage/terraform.tfvars ./terraform/prod/terraform.tfvars

tf-destroy-stage:
	@echo "+ $@"
	cd ./terraform/stage &&\
	terraform destroy --auto-approve=true

tf-output:
	@echo "+ $@"
	cd ./terraform/stage && \
	terraform output

tf-fmt:
	@echo "+ $@"
	cd ./terraform/stage && \
	terraform fmt ./..

tf-validate:
	@echo "+ $@"
	cd ./terraform/stage && \
	terraform validate ./..

# Ansible commands
ansible-up: ansible-update-ip-in-stage
	@echo "+ $@"
	cd ./ansible && make run

ansible-update-ip-in-stage:
	@echo "+ $@"
	cd ./terraform/stage && \
	terraform output | grep app_external_ip | awk '{print $$3}' | \
	xargs -I {} echo 'appserver ansible_host={}' | \
	xargs -I {} sed -i 's/appserver ansible_host=.*/{}/g' \
	./../../ansible/environments/stage/inventory

	cd ./terraform/stage && \
	terraform output | grep app_internal_ip | awk '{print $$3}' | \
	xargs -I {} echo 'App internal IP {} not be used'

	cd ./terraform/stage && \
	terraform output | grep db_external_ip | awk '{print $$3}' | \
	xargs -I {} echo 'dbserver ansible_host={}' | \
	xargs -I {} sed -i 's/dbserver ansible_host=.*/{}/g' \
	./../../ansible/environments/stage/inventory

	cd ./terraform/stage && \
	terraform output | grep db_internal_ip | awk '{print $$3}' | \
	xargs -I {} echo 'db_host: {}' | \
	xargs -I {} sed -i 's/db_host: .*/{}/g' \
	./../../ansible/environments/stage/group_vars/app
