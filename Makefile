FLAGS ?=

.PHONY:             \
	arch-devel      \
	arch-must-have  \
	suse-must-have  \
	setup-grub      \
	setup-kde       \
	add-home-users  \
	arch-add-trizen \
	arch-install-os \
	disable-ipv6    \
	upgrade-all     \
	upgrade-this

arch-devel:
	@ansible-playbook -K playbooks/arch-devel.yaml

arch-must-have:
	@ansible-playbook -K playbooks/arch-must-have.yaml

suse-must-have:
	@ansible-playbook -K playbooks/suse-must-have.yaml

setup-grub:
	@ansible-playbook -K playbooks/setup-grub.yaml

setup-kde:
	@ansible-playbook -K playbooks/setup-aur.yaml playbooks/setup-kde-only.yaml

add-home-users:
	@ansible-playbook --vault-password-file=vault-pass -i localhost-vault.yaml playbooks/add-home-users.yaml

arch-add-trizen:
	@ansible-playbook -K -i localhost.yaml playbooks/arch-add-trizen.yaml

arch-install-os:
	@lsblk
	@ansible-playbook -i localhost-not-ready.yaml playbooks/arch-install-os.yaml

# => -------------------------------------------------------------------------------------------------------------- {{{1

disable-ipv6:
	ansible-role roles/system/disable-ipv6 -K

upgrade-all:
	ansible-role roles/system/upgrade -K -i hosts.yaml -l all

upgrade-this:
	ansible-role roles/system/upgrade -K
