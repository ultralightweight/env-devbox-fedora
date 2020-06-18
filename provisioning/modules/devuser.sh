#!/bin/bash
# -----------------------------------------------------------------------------
# package: ultralight provisioning system
# author: Daniel Kovacs <mondomhogynincsen@gmail.com>
# licence: MIT <https://opensource.org/licenses/MIT>
# file-version: 1.0
# file-purpose: developer user creation module
# -----------------------------------------------------------------------------


# -----------------------------------------------------------
# _psh_devuser_configure
# -----------------------------------------------------------

function _psh_devuser_configure() {
    SYSTEM_PACKAGES+=(
    )
    DEVUSER_HOME=/home/${DEVUSER_NAME}
}


# -----------------------------------------------------------
# _psh_devuser_validate
# -----------------------------------------------------------

function _psh_devuser_validate() {
    :
}


# -----------------------------------------------------------
# _psh_devuser_pre_install
# -----------------------------------------------------------

function _psh_devuser_pre_install() {
    :
}


# -----------------------------------------------------------
# _psh_devuser_setup
# -----------------------------------------------------------

function _psh_devuser_setup() {

    # -----------------------------------------------------------
    # dev user creation
    # -----------------------------------------------------------

    _psh_log_info "setting up developer user ${DEVUSER_NAME}"
    if [ ! -d ${DEVUSER_HOME} ]; then
        useradd -u ${DEVUSER_UID} -g ${DEVUSER_GID} ${DEVUSER_NAME}
        echo -e "${DEVUSER_NAME}\tALL=(ALL)\tNOPASSWD: ALL" >> /etc/sudoers
    else
        _psh_log_notice "skip: dev user already exists"
    fi
    echo "${DEVUSER_NAME}:${DEVUSER_PASSWORD}" | chpasswd


    # -----------------------------------------------------------
    # ssh keys
    # -----------------------------------------------------------

    _psh_log_info "setting up ssh keys"

    mkdir -p ${DEVUSER_HOME}/.ssh

    if [[ -d ${PROVISIONER_CONFIG_CREDENTIALS_ROOT}/ssh ]]; then
        _psh_log_info "copying ssh configuration ..."
        cp -rv "${PROVISIONER_CONFIG_CREDENTIALS_ROOT}/ssh/." ${DEVUSER_HOME}/.ssh/
        rm -fv ${DEVUSER_HOME}/.ssh/.placeholder
    else
        _psh_log_warning "no ssh configuration found in: ${PROVISIONER_CONFIG_CREDENTIALS_ROOT}/ssh/"
    fi

    if [[ ! -f ${DEVUSER_HOME}/.ssh/authorized_keys ]]; then
        _psh_log_info "configuring authorized_keys..."
        cp /home/vagrant/.ssh/authorized_keys ${DEVUSER_HOME}/.ssh/authorized_keys
    else
        _psh_log_warning "sktip: authorized_keys already exists"
    fi

    chown -R ${DEVUSER_NAME}:${DEVUSER_GID} ${DEVUSER_HOME}/.ssh
    chmod 600 ${DEVUSER_HOME}/.ssh/*

    # -----------------------------------------------------------
    # invoking unprivilaged provisioner
    # -----------------------------------------------------------
    
    _psh_log_info "executing personalization with devuser: ${DEVUSER_NAME}"

    local module_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
    su - ${DEVUSER_NAME} ${module_root}/devuser-unprivileged.sh

}


# -----------------------------------------------------------
# _psh_devuser_verify
# -----------------------------------------------------------

function _psh_devuser_verify() {
    :
}

