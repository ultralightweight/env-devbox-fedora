#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.1
# file-purpose: docker support
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _ups_docker_configure
# -----------------------------------------------------------

function _ups_docker_configure() {
    SYSTEM_PACKAGES+=(
        docker-ce
        # docker-ce-18.06.3.ce-3.fc28
    )
}


# -----------------------------------------------------------
# _ups_docker_validate
# -----------------------------------------------------------

function _ups_docker_validate() {
    :
}


# -----------------------------------------------------------
# _ups_docker_pre_install
# -----------------------------------------------------------

function _ups_docker_pre_install() {

    if ! ls /etc/yum.repos.d/docker-ce* &> /dev/null; then
        _ups_log_info "adding docker-ce repositories..."
        dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    else
        _ups_log_notice "skip: docker-ce repositories are already installed."
    fi

}


# -----------------------------------------------------------
# _ups_docker_setup
# -----------------------------------------------------------

function _ups_docker_setup() {

    # -----------------------------------------------------------
    # step
    # -----------------------------------------------------------

    _ups_log_info "enabling and starting docker service..."
    systemctl enable docker
    systemctl start docker

    # -----------------------------------------------------------
    # add dev user
    # -----------------------------------------------------------

    if [ ! -z ${DEVUSER_NAME} ]; then
        _ups_log_info "granting permission for developer user to use docker: ${DEVUSER_NAME}"
        usermod -aG docker ${DEVUSER_NAME}
    else
        _ups_log_notice "skipped: permission for developer user: DEVUSER_NAME is not defined"
    fi

    if grep "31" /etc/fedora-release >/dev/null 2>&1; then 
        if ! grep "systemd.unified_cgroup_hierarchy" /etc/default/grub >/dev/null 2>&1; then
            _ups_log_info "Reverting system to use cgroups 1 (docker doesn't yet support cgroups2)"
            cp -vf /etc/default/grub /etc/default/grub.bak
            sed -i '/^GRUB_CMDLINE_LINUX/ s/"$/ systemd.unified_cgroup_hierarchy=0"/' /etc/default/grub
            _ups_log_info "Re-writing bootloader config... Please RESTART machine to be able to use docker."
            if ls /sys/firmware/efi >/dev/null 2>&1; then
                sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
            else
                sudo grub2-mkconfig -o /boot/grub2/grub.cfg
            fi
        fi
    fi

}


# -----------------------------------------------------------
# _ups_docker_verify
# -----------------------------------------------------------

function _ups_docker_verify() {
    :
}
