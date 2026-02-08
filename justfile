# https://just.systems/man/en/
# https://nodejs.org/en/learn/getting-started/introduction-to-nodejs

set export
export this := justfile()

[private]
@default:
	just --list --justfile "$this"

# => -------------------------------------------------------------------------------------------------------------- {{{1

# install development environment
arch-devel:
	ansible-playbook -K playbooks/arch-devel.yaml

# install development environment + work environment
arch-devel-work:
	ansible-playbook -K playbooks/arch-add-trizen.yaml playbooks/arch-devel-work.yaml

# install must-have tools
arch-must-have:
	ansible-playbook -K playbooks/arch-add-trizen.yaml playbooks/arch-must-have.yaml

# install AUR helper (prereq)
arch-add-trizen:
	ansible-playbook -K -i localhost.yaml playbooks/arch-add-trizen.yaml

# install operating system on a fresh machine
arch-install-os:
	lsblk
	ansible-playbook -i localhost-not-ready.yaml playbooks/arch-install-os.yaml

# => -------------------------------------------------------------------------------------------------------------- {{{1

# suse-must-have:
# 	ansible-playbook -K playbooks/suse-must-have.yaml

# => -------------------------------------------------------------------------------------------------------------- {{{1

# provision all users and home directories
add-home-users:
	# ansible-playbook --vault-password-file=vault-pass -i localhost-vault.yaml playbooks/add-home-users.yaml
	ansible-playbook -K --vault-password-file=vault-pass playbooks/add-home-users.yaml

# setup-grub:
# 	ansible-playbook -K playbooks/setup-grub.yaml

# install basic KDE environment
setup-kde:
	ansible-playbook -K playbooks/setup-kde-only.yaml

# install full KDE environment
setup-kde-full:
	ansible-playbook -K playbooks/setup-kde.yaml

# install podman
@setup-podman:
	ansible-role roles/has/app/podman -K

# => -------------------------------------------------------------------------------------------------------------- {{{1

# disable IPv6 support
disable-ipv6:
	ansible-role roles/system/disable-ipv6 -K

# upgrade all machines
upgrade-all:
	ansible-role roles/system/upgrade -K -i hosts.yaml -l all

# upgrade localhost
upgrade-this:
	ansible-role roles/system/upgrade -K

# sign SSH host key
sign-ssh-host-key host:
	ansible-playbook -K playbooks/sign-ssh-host-key.yaml -i "$host,"

# => -------------------------------------------------------------------------------------------------------------- {{{1

# install necessary ansible modules
prepare:
    ansible-galaxy collection install community.crypto

# edit vault encrypted file
@edit file:
	ansible-vault edit --vault-password-file=vault-pass "$file"
