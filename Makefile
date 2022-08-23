# -----------------------------------------------------------------------------
# description: General Project Makefile
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: GPL3 <https://opensource.org/licenses/GPL3>
# version: 2.1.1
# supported: vagrant
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# package config
# -----------------------------------------------------------------------------

DEVBOX_MOUNT_ROOT_PATH=~/repos/devbox
# DEVBOX_MOUNT_ROOT_PATH=../../devbox-root-35
# DEVBOX_HOSTONLY_IP=192.168.33.101
# DEVBOX_HOSTONLY_IP=10.0.2.15
DEVBOX_HOSTONLY_IP=192.168.64.3
DEVBOX_USER_NAME="dev"

# -----------------------------------------------------------------------------
# vm-start
# -----------------------------------------------------------------------------

vm-start::
	vagrant up

vm:: vm-start


# -----------------------------------------------------------------------------
# vm-stop
# -----------------------------------------------------------------------------

vm-stop::
	vagrant halt


# -----------------------------------------------------------------------------
# vm-provision
# -----------------------------------------------------------------------------

vm-provision::
	vagrant rsync
	vagrant provision


# -----------------------------------------------------------------------------
# vm-restart
# -----------------------------------------------------------------------------

vm-restart::
	vagrant halt
	vagrant up


# -----------------------------------------------------------------------------
# vm-recreate
# -----------------------------------------------------------------------------

vm-recreate::
	vagrant destroy
	vagrant up


# -----------------------------------------------------------------------------
# vm-destroy
# -----------------------------------------------------------------------------

vm-destroy::
	vagrant destroy


# -----------------------------------------------------------------------------
# vm-portforwards
# -----------------------------------------------------------------------------

vm-portforwards::
	vagrant ssh -- \
		-l dev \
		-A \
		-L10080:127.0.0.1:80 \
		-L8000:127.0.0.1:8000 \
		-L8080:127.0.0.1:8080 \
		-L8081:127.0.0.1:8081 \
		-L8089:127.0.0.1:8089 \
		-L8888:127.0.0.1:8888 \
		-L9090:127.0.0.1:9090 \
		-L9099:127.0.0.1:9090 \
		-L9999:127.0.0.1:9999 \
		-L9013:127.0.0.1:9013 \
		-L4200:127.0.0.1:4200 \
		-L15000:127.0.0.1:15000


# -----------------------------------------------------------------------------
# vm-ssh
# -----------------------------------------------------------------------------

vm-ssh::
	vagrant ssh -- -l dev -A


# -----------------------------------------------------------------------------
# vm-mount
# -----------------------------------------------------------------------------

## From: https://stackoverflow.com/questions/63562811/nfs-mount-keep-changing-inode

vm-mount-root::
	@echo "Mounting root filesystem of the VM to $(DEVBOX_MOUNT_ROOT_PATH)"
	mkdir -p $(DEVBOX_MOUNT_ROOT_PATH)
	mount -o rw,nolocks,locallocks,nordirplus -t nfs $(DEVBOX_HOSTONLY_IP):/ $(DEVBOX_MOUNT_ROOT_PATH)
	@echo "Contents of the mounted directory:"
	ls -la $(DEVBOX_MOUNT_ROOT_PATH)

vm-mount::
	@echo "Mounting root filesystem of the VM to $(DEVBOX_MOUNT_ROOT_PATH)-dev"
	mkdir -p $(DEVBOX_MOUNT_ROOT_PATH)-dev
	mount -o rw,nolocks,locallocks,nordirplus -t nfs $(DEVBOX_HOSTONLY_IP):/home/dev $(DEVBOX_MOUNT_ROOT_PATH)-dev
	@echo "Contents of the mounted directory:"
	ls -la $(DEVBOX_MOUNT_ROOT_PATH)-dev

mount:: vm-mount


mount-status:
	nfsstat -m


# =============================================================================
# remote operation
# =============================================================================


# -----------------------------------------------------------------------------
# remote-setup-keys
# -----------------------------------------------------------------------------

# remote-setup-keys::
# 	public_key=$$(cat ~/.ssh/id_rsa.pub) && \
# 	ssh $(DEVBOX_USER_NAME)@$(DEVBOX_HOSTONLY_IP) -c sudo "mkdir -p ~/.ssh; chmod 700 ~/.ssh; echo '${public_key}' >> ~/.ssh/authorized_keys;"


# -----------------------------------------------------------------------------
# remote-ssh
# -----------------------------------------------------------------------------

remote-ssh::
	ssh -A $(DEVBOX_USER_NAME)@$(DEVBOX_HOSTONLY_IP)


# -----------------------------------------------------------------------------
# remote-ssh-root
# -----------------------------------------------------------------------------

remote-ssh-root::
	ssh -A root@$(DEVBOX_HOSTONLY_IP)


# -----------------------------------------------------------------------------
# remote-portforwards
# -----------------------------------------------------------------------------

remote-portforwards::
	ssh $(DEVBOX_USER_NAME)@$(DEVBOX_HOSTONLY_IP) \
		-A \
		-L10080:127.0.0.1:80 \
		-L8000:127.0.0.1:8000 \
		-L8080:127.0.0.1:8080 \
		-L8081:127.0.0.1:8081 \
		-L8089:127.0.0.1:8089 \
		-L8888:127.0.0.1:8888 \
		-L9090:127.0.0.1:9090 \
		-L9099:127.0.0.1:9090 \
		-L9999:127.0.0.1:9999 \
		-L9013:127.0.0.1:9013 \
		-L4200:127.0.0.1:4200 \
		-L15000:127.0.0.1:15000


# -----------------------------------------------------------------------------
# remote-sync
# -----------------------------------------------------------------------------

remote-sync::
	rsync \
		-avzh \
		--exclude ".git" \
		. \
		root@$(DEVBOX_HOSTONLY_IP):/vagrant/

# -----------------------------------------------------------------------------
# remote-provision
# -----------------------------------------------------------------------------

remote-provision:: remote-sync
	ssh -A root@$(DEVBOX_HOSTONLY_IP) /vagrant/provisioning/provision.sh




# -----------------------------------------------------------------------------
# aliases
# -----------------------------------------------------------------------------

# pf:: vm-portforwards
# ssh:: vm-ssh

pf:: remote-portforwards
ssh:: remote-ssh


