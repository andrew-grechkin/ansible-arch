# ansible-arch

Basic ansible scripts to install and setup Arch my way

## Installation

* `ansible-playbook playbooks/install.yaml`
* reboot
* `ansible-playbook playbooks/install-users.yaml --ask-become-pass --ask-vauld-pass`

### Setup

* `ansible-playbook playbooks/setup-kde-min.yaml -K`
* reboot
