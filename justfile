# https://just.systems/man/en/
# https://nodejs.org/en/learn/getting-started/introduction-to-nodejs

set export
export this := justfile()

[private]
@default:
	just --list --justfile "$this"

# => -------------------------------------------------------------------------------------------------------------- {{{1

# install development environment
arch-devel host='localhost':
	ansible-playbook -K --limit "$host" playbooks/arch-devel.yaml

# install development environment + work environment
arch-devel-work host='localhost':
	ansible-playbook -K --limit "$host" playbooks/arch-add-trizen.yaml playbooks/arch-devel-work.yaml

# install must-have tools
arch-must-have host='localhost':
	ansible-playbook -K --limit "$host" playbooks/arch-add-trizen.yaml playbooks/arch-must-have.yaml

# install AUR helper (prereq)
arch-add-trizen host='localhost':
	ansible-playbook -K --limit "$host" playbooks/arch-add-trizen.yaml

# install operating system on a fresh machine
arch-install-os:
	lsblk
	ansible-playbook -i localhost-not-ready.yaml playbooks/arch-install-os.yaml

# => -------------------------------------------------------------------------------------------------------------- {{{1

# suse-must-have:
# 	ansible-playbook -K playbooks/suse-must-have.yaml

# => -------------------------------------------------------------------------------------------------------------- {{{1

# setup network stack
setup-network host='localhost':
	ansible-playbook -K --limit "$host" playbooks/setup-network-stack.yaml

# sign SSH host key
setup-ssh host='localhost':
	ansible-playbook -K --limit "$host" playbooks/setup-ssh.yaml

# provision all users and home directories
add-home-users host='localhost':
	ansible-playbook -K --limit "$host" --vault-password-file=vault-pass playbooks/add-home-users.yaml

# setup-grub:
# 	ansible-playbook -K playbooks/setup-grub.yaml

# install basic KDE environment
setup-kde host='localhost':
	ansible-playbook -K --limit "$host" playbooks/setup-kde-only.yaml

# install full KDE environment
setup-kde-full host='localhost':
	ansible-playbook -K --limit "$host" playbooks/setup-kde.yaml

# install podman
@setup-podman:
	ansible-role roles/has/app/podman -K

# => -------------------------------------------------------------------------------------------------------------- {{{1

# upgrade all machines
upgrade-all:
	ansible-role roles/system/upgrade -K -i hosts.yaml -l all

# upgrade localhost
upgrade-this:
	ansible-role roles/system/upgrade -K

# => -------------------------------------------------------------------------------------------------------------- {{{1

# install necessary ansible modules
prepare:
    ansible-galaxy collection install community.crypto

# edit vault encrypted file
@edit file:
	ansible-vault edit --vault-password-file=vault-pass "$file"
