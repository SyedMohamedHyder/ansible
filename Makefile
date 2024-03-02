.PHONY: ansible-helm
ansible-helm:
	helm install ansible helm/ansible --namespace ansible --create-namespace
