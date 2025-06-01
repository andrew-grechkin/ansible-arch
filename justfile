# https://just.systems/man/en/
# https://nodejs.org/en/learn/getting-started/introduction-to-nodejs

@default:
	just --list --justfile {{justfile()}}

# => -------------------------------------------------------------------------------------------------------------- {{{1

arch-devel:
	ansible-playbook -K playbooks/arch-devel.yaml

arch-devel-work:
	ansible-playbook -K playbooks/arch-add-trizen.yaml playbooks/arch-devel-work.yaml

arch-must-have:
	ansible-playbook -K playbooks/arch-add-trizen.yaml playbooks/arch-must-have.yaml

arch-add-trizen:
	ansible-playbook -K -i localhost.yaml playbooks/arch-add-trizen.yaml

arch-install-os:
	lsblk
	ansible-playbook -i localhost-not-ready.yaml playbooks/arch-install-os.yaml

# => -------------------------------------------------------------------------------------------------------------- {{{1

suse-must-have:
	ansible-playbook -K playbooks/suse-must-have.yaml

# => -------------------------------------------------------------------------------------------------------------- {{{1

add-home-users:
	ansible-playbook --vault-password-file=vault-pass -i localhost-vault.yaml playbooks/add-home-users.yaml

setup-grub:
	ansible-playbook -K playbooks/setup-grub.yaml

setup-kde:
	ansible-playbook -K playbooks/setup-kde-only.yaml

setup-kde-full:
	ansible-playbook -K playbooks/setup-kde.yaml

setup-podman:
	ansible-role roles/has/app/podman -K

# => -------------------------------------------------------------------------------------------------------------- {{{1

disable-ipv6:
	ansible-role roles/system/disable-ipv6 -K

upgrade-all:
	ansible-role roles/system/upgrade -K -i hosts.yaml -l all

upgrade-this:
	ansible-role roles/system/upgrade -K
