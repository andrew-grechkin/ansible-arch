.PHONY:           \
	install       \
	install-users \
	setup-kde     \
	upgrade-all   \
	upgrade-this

install:
	@lsblk
	@ansible-playbook playbooks/install.yaml

install-users:
	@ansible-playbook playbooks/install-users.yaml -i localhost.yaml -K --ask-vault-pass

must-have:
	@ansible-playbook -K playbooks/must-have.yaml

setup-kde:
	@echo "Updating pacman mirrors..."
	@sudo systemctl restart reflector
	@echo "Applying playbooks..."
	@ansible-playbook playbooks/setup-basic.yaml playbooks/setup-kde.yaml -K

upgrade-all:
	ansible-role roles/system/upgrade -i hosts.yaml -l all -K --ask-vault-pass

upgrade-this:
	ansible-role roles/system/upgrade -i localhost.yaml -K

disable-ipv6:
	ansible-role roles/system/disable-ipv6 -K -i localhost.yaml
