FLAGS ?=

.PHONY:            \
	install        \
	install-users  \
	arch-devel     \
	arch-must-have \
	suse-must-have \
	setup-kde      \
	disable-ipv6   \
	upgrade-all    \
	upgrade-this

install:
	@lsblk
	@ansible-playbook -i localhost-not-ready.yaml playbooks/install.yaml

install-users:
	@ansible-playbook --vault-password-file=vault-pass -i localhost-vault.yaml playbooks/install-users.yaml

arch-devel:
	@ansible-playbook -K playbooks/arch-devel.yaml

arch-must-have:
	@ansible-playbook -K playbooks/arch-must-have.yaml

suse-must-have:
	@ansible-playbook -K playbooks/suse-must-have.yaml

setup-grub:
	@ansible-playbook -K playbooks/grub.yaml

setup-kde:
	@ansible-playbook -K playbooks/setup-aur.yaml playbooks/setup-kde-only.yaml

disable-ipv6:
	ansible-role roles/system/disable-ipv6 -K

upgrade-all:
	ansible-role roles/system/upgrade -K -i hosts.yaml -l all

upgrade-this:
	ansible-role roles/system/upgrade -K
