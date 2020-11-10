# ansible-arch

Basic ansible scripts to install and setup Arch my way

## Installation

* `ansible-playbook playbooks/install.yaml`
* reboot
* fetch roles/private
* `ansible-playbook playbooks/install-users.yaml`
* reboot

### Setup

* `ansible-playbook playbooks/setup-kde-min.yaml --ask-become-pass`
* reboot
