.PHONY:           \
	install       \
	install-users \
	upgrade-all   \
	upgrade-this

install:
	@lsblk
	@ansible-playbook playbooks/install.yaml

install-users:
	ansible-playbook playbooks/install-users.yaml -i localhost.yaml -K --ask-vault-pass

upgrade-all:
	ansible-role roles/system/upgrade -i hosts.yaml -K --hosts all --ask-vault-pass

upgrade-this:
	ansible-role roles/system/upgrade -i localhost.yaml -K
