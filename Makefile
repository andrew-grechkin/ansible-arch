.PHONY:           \
	install       \
	install-users

install:
	@lsblk
	@ansible-playbook playbooks/install.yaml

install-users:
	ansible-playbook playbooks/install-users.yaml -i localhost.yaml -K --ask-vault-pass
